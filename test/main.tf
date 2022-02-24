provider "kubernetes" {

    config_path = "~/.kube/config"

}

module "test" {

    source                 = "../"
    namespace              = "default"
    elasticsearch_host     = "cluster-1-es-http"
    elasticsearch_port     = 9200
    elasticsearch_scheme   = "http"
    elasticsearch_username = "admin"
    elasticsearch_password = "Agby5kma0130"
    fluent_conf            = <<EOF

    #
    # Drop fluentd logs themselves.
    #
    <match fluent.**>

        @type null

    </match>

    <source>
      type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-containers.log.pos
      time_format %Y-%m-%dT%H:%M:%S.%NZ
      tag kubernetes.*
      format json
      read_from_head true
    </source>

    # Query the API for extra metadata.
    <filter kubernetes.**>
      type kubernetes_metadata
      # If the logs begin with '{' and end with '}' then it's JSON so merge
      # the JSON log field into the log event
      merge_json_log true
      preserve_json_log true
    </filter>
    # rewrite_tag_filter does not support nested fields like
    # kubernetes.container_name, so this exists to flatten the fields
    # so we can use them in our rewrite_tag_filter

    <filter kubernetes.**>
      @type record_transformer
      enable_ruby true
      <record>
        kubernetes_namespace_container_name $${record["kubernetes"]["namespace_name"]}.$${record["kubernetes"]["container_name"]}
      </record>
    </filter>
    # retag based on the container name of the log message
    <match kubernetes.**>
      @type rewrite_tag_filter
      rewriterule1 kubernetes_namespace_container_name  ^(.+)$ kube.$1
    </match>
    # Remove the unnecessary field as the information is already available on
    # other fields.
    <filter kube.**>
      @type record_transformer
      remove_keys kubernetes_namespace_container_name
    </filter>
    <filter kube.kube-system.**>
      type parser
      format kubernetes
      reserve_data true
      key_name log
      suppress_parse_error_log true
      ignore_key_not_exist true
    </filter>

    EOF

}
