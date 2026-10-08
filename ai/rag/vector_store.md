# Vector Database Architecture (`vector_store`)

## 1. Overview
Defines vector database setup, index types, metadata schema, and connection configuration.

## 2. Purpose
Provides high-performance vector storage and fast nearest-neighbor (HNSW) similarity searches.

## 3. Responsibilities
- Store 1536-dimensional embeddings paired with document text and metadata.
- Execute HNSW vector similarity queries under 20ms latency.
- Support metadata filtering (e.g. `category = "refunds"`).

## 4. Inputs
- Upsert payload or query vector.

## 5. Outputs
- Top-K matching vector record objects.

## 6. Dependencies
- `rag/embeddings.md`
- `shared/constants.md`

## 7. Related Files
- [retrieval.md](retrieval.md)
- [indexing.md](indexing.md)
- [../shared/constants.md](../shared/constants.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Vector Store Specs

| Property | Specification |
| :--- | :--- |
| **Engine** | PgVector / Qdrant / Pinecone |
| **Index Type** | HNSW (`m=16`, `ef_construction=64`) |
| **Metric** | Cosine Distance |
| **Query Latency SLA** | < 20ms |

## 10. Edge Cases
- Empty index query: Returns empty match array with zero score.

## 11. Error Handling
- Connection pool failures raise `RAG_VECTOR_STORE_UNAVAILABLE` error.

## 12. Extension Points
- Multi-tenant vector index partitioning per enterprise account.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- HNSW Indexing Specification.
