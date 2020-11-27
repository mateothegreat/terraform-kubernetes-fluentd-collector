module "test" {

    source = "../"
    namespace = "default"

    elasticsearch_host = "cluster-1-es-http"
    elasticsearch_port = 9200
    elasticsearch_scheme = "https"
    elasticsearch_username = "elastic"
    elasticsearch_password = "changeme"

}
