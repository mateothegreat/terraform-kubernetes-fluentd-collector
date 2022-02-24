See [test/main.tf](test/main.tf)

```json
GET /logstash-*/_search
{
    "size": 0,
    "aggs": {
        "name": {
            "terms": {
                "field": "kubernetes.container_name.keyword"
            }
        }
    }
}
```

```json
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 10000,
            "relation": "gte"
        },
        "max_score": null,
        "hits": []
    },
    "aggregations": {
        "name": {
            "doc_count_error_upper_bound": 0,
            "sum_other_doc_count": 0,
            "buckets": [
                {
                    "key": "fluentd",
                    "doc_count": 12804
                },
                {
                    "key": "spotinst-kubernetes-cluster-controller",
                    "doc_count": 595
                },
                {
                    "key": "kube-proxy",
                    "doc_count": 206
                },
                {
                    "key": "kibana",
                    "doc_count": 134
                },
                {
                    "key": "keda-operator",
                    "doc_count": 73
                },
                {
                    "key": "ingress-controller-ops",
                    "doc_count": 60
                },
                {
                    "key": "elasticsearch",
                    "doc_count": 20
                },
                {
                    "key": "thanos-sidecar",
                    "doc_count": 15
                },
                {
                    "key": "kube-state-metrics",
                    "doc_count": 2
                }
            ]
        }
    }
}

```
