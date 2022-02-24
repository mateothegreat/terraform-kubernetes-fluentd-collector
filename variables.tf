variable "namespace" {

    type        = string
    description = "cluster namespace"

}

variable "elasticsearch_host" {

    type        = string
    description = "elasticsearch url to send logs to"

}

variable "elasticsearch_port" {

    type        = string
    description = "elasticsearch port to send logs to"

}

variable "elasticsearch_scheme" {

    type        = string
    description = "elasticsearch scheme to send logs to"

}

variable "elasticsearch_username" {

    type        = string
    description = "elasticsearch username"

}

variable "elasticsearch_password" {

    type        = string
    description = "elasticsearch password"

}

variable "fluent_conf" {

    type        = string
    description = "fluent configuration"

}
