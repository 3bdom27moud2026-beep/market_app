# Embedding Model & Dense Vector Specs (`embeddings`)

## 1. Overview
Defines dense vector embedding model specifications, dimension parameters, and batching rules.

## 2. Purpose
Transforms text chunks and customer queries into high-dimensional vector representations for semantic search.

## 3. Responsibilities
- Generate 1536-dimensional dense vectors using `text-embedding-3-small` (or 768-dimensional via `Gecko`).
- Normalize vector representations to L2 unit length for cosine similarity calculations.
- Batch embedding requests up to 100 chunks per API call.

## 4. Inputs
- Document chunks from `rag/chunking.md` or query strings.

## 5. Outputs
- Floating-point vector arrays (e.g. `[0.0142, -0.0891, ...]`).

## 6. Dependencies
- `rag/chunking.md`
- `config/providers.md`

## 7. Related Files
- [chunking.md](chunking.md)
- [vector_store.md](vector_store.md)
- [retrieval.md](retrieval.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Embedding Spec Table

| Property | Value |
| :--- | :--- |
| **Model** | `text-embedding-3-small` |
| **Dimensions** | 1536 |
| **Distance Metric** | Cosine Similarity |
| **Batch Size** | 100 chunks |

## 10. Edge Cases
- Non-English input: Embedding model automatically handles multilingual embeddings (Arabic/English).

## 11. Error Handling
- Provider rate limits trigger failover to secondary embedding model (`text-embedding-gecko`).

## 12. Extension Points
- Fine-tuned domain embedding adapters.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- OpenAI Embedding Specifications.
