---
name: api-design
description: Guidelines for designing and changing HTTP/REST APIs, covering resource naming, status codes, error formats, pagination, versioning and backwards compatibility. Use when adding or changing API endpoints, request or response schemas, or reviewing an API design.
---

# API design

Follow the project's existing API conventions first. Use these guidelines where the project has none.

## Resources and methods

- Name resources with plural nouns: `/users`, `/users/{id}/orders`. Avoid verbs in paths.
- Use methods for their meaning:
  - `GET` reads and never changes state.
  - `POST` creates, or runs an action that doesn't fit a resource.
  - `PUT` replaces a whole resource. `PATCH` updates part of one.
  - `DELETE` removes.
- `GET`, `PUT` and `DELETE` must be idempotent. For `POST` endpoints where retries are likely, such as payments, accept an `Idempotency-Key` header.
- Keep nesting shallow. One level (`/users/{id}/orders`) is usually enough.

## Requests and responses

- Use one casing style for JSON fields across the whole API, matching what the project already uses.
- Return the created or updated resource from `POST`, `PUT` and `PATCH`.
- Use ISO 8601 timestamps in UTC, such as `2026-01-31T12:00:00Z`.
- Represent IDs as strings, so they can change format later without breaking clients.
- Don't expose internal details such as database column names, stack traces or internal IDs.

## Status codes

| Code | When |
|---|---|
| `200` | Success with a body |
| `201` | Created. Include a `Location` header |
| `204` | Success with no body |
| `400` | Malformed request or failed validation |
| `401` | Not authenticated |
| `403` | Authenticated but not allowed |
| `404` | Resource doesn't exist, or the caller may not know it exists |
| `409` | Conflict with the current state, such as a duplicate or a version mismatch |
| `422` | Well-formed but semantically invalid, if the project distinguishes this from `400` |
| `429` | Rate limited. Include `Retry-After` |
| `500` | Unexpected server error |

## Errors

Return errors in one consistent shape. If the project has none, use something like:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Human-readable summary",
    "details": [{ "field": "email", "message": "must be a valid email address" }]
  }
}
```

`code` is stable and machine-readable. `message` is for people and can change.

## Lists

- Paginate every list endpoint from the start. Adding pagination later is a breaking change.
- Prefer cursor pagination (`?cursor=...&limit=50`, returning `next_cursor`) for large or frequently changing data. Offset pagination is fine for small, stable data.
- Cap `limit` and document the default.
- Support filtering and sorting with query parameters, such as `?status=active&sort=-created_at`.

## Backwards compatibility

These changes are safe:
- Adding an endpoint
- Adding an optional request field
- Adding a response field

These changes break clients:
- Removing or renaming a field or endpoint
- Changing a field's type or meaning
- Making an optional field required
- Changing status codes or error codes

For a breaking change, add a new version (`/v2/...` or a version header, whichever the project uses) and keep the old one working until clients have moved. Mark deprecated endpoints with a `Deprecation` header and document when they'll be removed.

## Before finishing

- Update the API spec or docs, such as OpenAPI, if the project has them.
- Add tests for success, validation errors, authorization failures and not-found cases.
