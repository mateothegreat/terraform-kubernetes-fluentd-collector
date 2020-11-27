provider "kubernetes" {

    host     = var.host
    token    = var.token
    insecure = var.insecure

}

resource "kubernetes_service_account" "fluentd" {

    metadata {

        name      = "fluentd"
        namespace = var.namespace

    }

}

resource "kubernetes_cluster_role" "fluentd" {

    metadata {

        name = "fluentd"

    }

    rule {

        api_groups = [ "*" ]
        verbs      = [ "get", "list", "watch" ]
        resources  = [ "pods", "namespaces" ]

    }

}

resource "kubernetes_cluster_role_binding" "fluentd" {

    metadata {

        name = "fluentd"

    }

    role_ref {

        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "fluentd"

    }

    subject {

        kind      = "ServiceAccount"
        name      = "fluentd"
        namespace = var.namespace

    }

}

resource "kubernetes_config_map" "fluentd" {

    metadata {

        name      = "fluentd-config"
        namespace = var.namespace

    }

    data = {

        "fluent.conf" = <<EOF

            <match fluent.**>
                # this tells fluentd to not output its log on stdout
                @type null
            </match>

        EOF

    }

}

resource "kubernetes_daemonset" "fluentd" {

    metadata {

        name      = "fluentd"
        namespace = var.namespace

        labels = {

            app = "fluentd"

        }

    }

    spec {

        selector {

            match_labels = {

                app = "fluentd"

            }

        }

        template {

            metadata {

                labels = {

                    app = "fluentd"

                }

            }

            spec {

                service_account_name            = "fluentd"
                automount_service_account_token = true

                toleration {

                    key    = "node-role.kubernetes.io/master"
                    effect = "NoSchedule"

                }

                container {

                    name  = "fluentd"
                    image = "fluent/fluentd-kubernetes-daemonset:v1.11-debian-elasticsearch7-1"

                    env {

                        name  = "FLUENT_ELASTICSEARCH_HOST"
                        value = var.elasticsearch_host

                    }

                    env {

                        name  = "FLUENT_ELASTICSEARCH_PORT"
                        value = var.elasticsearch_port

                    }

                    env {

                        name  = "FLUENT_ELASTICSEARCH_SCHEME"
                        value = var.elasticsearch_scheme

                    }

                    env {

                        name  = "FLUENT_ELASTICSEARCH_SSL_VERIFY"
                        value = "false"

                    }

                    env {

                        name  = "FLUENT_ELASTICSEARCH_USER"
                        value = var.elasticsearch_username

                    }

                    env {

                        name  = "FLUENT_ELASTICSEARCH_PASSWORD"
                        value = var.elasticsearch_password

                    }

                    env {

                        name  = "FLUENT_UID"
                        value = 0

                    }

                    env {

                        name  = "FLUENTD_SYSTEMD_CONF"
                        value = "disable"

                    }

                    resources {

                        limits {

                            cpu    = "200m"
                            memory = "200Mi"

                        }

                        requests {

                            cpu    = "200m"
                            memory = "200Mi"

                        }

                    }

                    volume_mount {

                        mount_path = "/var/log"
                        name       = "varlog"

                    }

                    volume_mount {

                        mount_path = "/var/lib/docker/containers"
                        name       = "varlibdockercontainers"
                        read_only  = true

                    }

#                    volume_mount {
#
#                        mount_path = "/fluentd/etc"
#                        sub_path   = "fluentd.conf"
#                        name       = "fluentd-config"
#
#                    }

                }

                termination_grace_period_seconds = 30

                volume {

                    name = "varlog"

                    host_path {

                        path = "/var/log"

                    }

                }

                volume {

                    name = "varlibdockercontainers"

                    host_path {

                        path = "/var/lib/docker/containers"

                    }

                }

#                volume {
#
#                    name = "fluentd-config"
#
#                    config_map {
#
#                        name = "fluentd-config"
#
#                    }
#
#                }

            }

        }

    }

}
