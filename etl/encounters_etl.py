import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
import psycopg2


class ReadEncounters(beam.DoFn):
    def process(self,element):

        hostname = "olye3.h.filess.io"
        database = "radichealthcare_rearburied"
        port = "5433"
        username = "radichealthcare_rearburied"
        password = "0faa3d7a3228960d4e6049300dfce8887de942b2"

        # Establish Connection with the Online Database
        conn = psycopg2.connect(database=database, user=username,\
                         password=password, host=hostname, port=port)
        
        # Create a cursor object
        cursor = conn.cursor()
        # Execute a query to fetch data from the diagnosis table
        cursor.execute("SELECT * FROM healthcare.diagnoses")
        # Fetch all rows from the executed query
        rows = cursor.fetchall()
    
        for row in rows:
            yield dict(zip([desc[0] for desc in cursor.description], row))

        # Close the cursor and connection
        cursor.close()
        conn.close()


def run():
    # Define the pipeline options
    options = PipelineOptions(
        runner='DirectRunner',
        project='seraphic-disk-459415-k0',
        temp_location='gs://radichealthcarebucket/temp',
        region='us-central1'
    )

    # Create a Beam pipeline
    with beam.Pipeline(options=options) as p:
        # Read data from the diagnosis table
        diagnosis_data = (
            p
            | 'ReadEncounters' >> beam.Create([None])
            | 'FetchEncounters' >> beam.ParDo(ReadEncounters())
            | 'WriteToBigQuery' >> beam.io.WriteToBigQuery(
                'seraphic-disk-459415-k0:radichealthcaredataset.encounters',
                schema='SCHEMA_AUTODETECT',
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
                create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
            )
        )



if __name__ == '__main__':
    run()