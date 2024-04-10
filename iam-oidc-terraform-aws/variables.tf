variable "environment" {
  description = "Env tags"
  type        = string
  default     = ""
}

variable "cluster_name" {
  default = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "A mapping of tags to assign to the resource"
  type        = any
  default     = []
}
