---
name: database-migrations
description: How to write safe, reversible database schema and data migrations that don't cause downtime or lose data. Use when creating or reviewing migrations, changing database schemas, adding indexes or constraints, or renaming or removing columns or tables.
---

# Database migrations

Use the project's migration tool and conventions, such as Alembic, Django, Rails, Prisma, Flyway, golang-migrate or sqlx. Generate migration files with the tool rather than writing them from scratch, and never edit a migration that has already been applied in a shared environment. Write a new one instead.

## Principles

- **Assume old and new code run at the same time.** During a deploy, the previous version of the app still runs against the new schema. Every migration must work with both.
- **Keep schema changes and data changes separate.** Put large data backfills in their own migration or a background job, not in the same transaction as schema changes.
- **Make every migration reversible** where possible, and write the down migration. If it truly can't be reversed, such as when dropping data, say so in the migration.
- **Never lose data by accident.** Dropping a column or table is permanent. Do it in a later release, after nothing reads it.

## Expand, then contract

Never rename or change the type of a column in one step. Split it across releases:

1. **Expand.** Add the new column or table, nullable or with a default. Deploy code that writes to both the old and new columns.
2. **Migrate.** Backfill the new column from the old one, in batches.
3. **Switch.** Deploy code that reads from the new column.
4. **Contract.** In a later release, stop writing the old column, then drop it.

The same pattern applies to renaming tables, splitting tables and changing a column's meaning.

## Operations that lock or rewrite tables

On large tables, these can block reads or writes for a long time. Check the behavior for the project's database and version.

| Operation | Safer approach |
|---|---|
| Adding an index | PostgreSQL: `CREATE INDEX CONCURRENTLY`, outside a transaction. MySQL: `ALGORITHM=INPLACE, LOCK=NONE` |
| Adding a `NOT NULL` column | Add it nullable, backfill, then add the constraint |
| Adding a foreign key or check constraint | PostgreSQL: add it `NOT VALID`, then `VALIDATE CONSTRAINT` separately |
| Changing a column type | Expand and contract with a new column |
| Large `UPDATE` or `DELETE` | Batch it, for example 1,000 to 10,000 rows at a time, committing between batches |

Set a lock timeout, such as `SET lock_timeout = '5s'` in PostgreSQL, so a migration fails fast instead of queuing behind long-running queries and blocking everything after it.

## Checklist

- [ ] Works with both the old and new versions of the application code
- [ ] Has a working down migration, or a comment explaining why it can't
- [ ] No long locks on large tables
- [ ] Backfills are batched and can be resumed if interrupted
- [ ] New columns that need lookups have indexes
- [ ] Tested by running up, down and up again against a local database
- [ ] Application models or schema files are updated to match
