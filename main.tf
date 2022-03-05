module "label_name_db" {
  source     = "r0ck40k/label/generic"
  version    = "0.1.0"
  context    = var.context
  attributes = ["db", var.name]
}
resource "mysql_database" "this" {
  name = module.label_name_db.id
}
resource "random_password" "this" {
  length = 32
}
resource "random_string" "this" {
  length  = 16
  special = false
}
resource "mysql_user" "this" {
  user               = random_string.this.result
  plaintext_password = random_password.this.result
  host               = "%"
}
resource "mysql_grant" "this" {
  database = mysql_database.this.name
  user     = mysql_user.this.user
  host     = "%"
  privileges = [
    "SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "REFERENCES", "INDEX", "ALTER", "CREATE TEMPORARY TABLES",
    "LOCK TABLES", "EXECUTE", "CREATE VIEW", "SHOW VIEW", "CREATE ROUTINE", "ALTER ROUTINE", "EVENT", "TRIGGER"
  ]
}
