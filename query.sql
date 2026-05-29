-- name: GetAccount :one
SELECT id, email_address, created_at
FROM account
WHERE id = $1;	
