variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "The name of the task family"
  type        = string
}

variable "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document"
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "A set of launch types required by the task"
  type        = set(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "The number of cpu units used by the task"
  type        = string
}

variable "memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the task execution role that grants the Amazon ECS container agent permission to call AWS APIs on your behalf"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the IAM role that containers in this task can assume"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "The number of instances of the task definition to run"
  type        = number
}

variable "launch_type" {
  description = "The launch type on which to run your service"
  type        = string
  default     = "FARGATE"

}

variable "subnet_ids" {
  description = "A list of subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs for the ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ECS service"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name prefix for the associated project resource"
  type        = string
}

variable "env" {
  description = "The environment prefix for the associated project resource"
  type        = string
}