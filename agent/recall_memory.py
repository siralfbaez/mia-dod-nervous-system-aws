import psycopg2
from pgvector.psycopg2 import register_vector
import os

class MemoryBank:
    def __init__(self):
        self.conn = psycopg2.connect(
            host=os.getenv("AURORA_HOST"),
            database="postgres",
            user="admin",
            password=os.getenv("AURORA_PASSWORD")
        )
        register_vector(self.conn)

    def recall_similar_events(self, query_embedding, limit=5):
        """Finds historical matches for new telemetry."""
        cur = self.conn.cursor()
        query = "SELECT source_id, payload FROM nervous_system.telemetry_vectors ORDER BY embedding <-> %s LIMIT %s"
        cur.execute(query, (query_embedding, limit))
        return cur.fetchall()

    def store_memory(self, source_id, payload, embedding):
        """Saves new telemetry into the vector store."""
        cur = self.conn.cursor()
        cur.execute(
            "INSERT INTO nervous_system.telemetry_vectors (source_id, payload, embedding) VALUES (%s, %s, %s)",
            (source_id, payload, embedding)
        )
        self.conn.commit()