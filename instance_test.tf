resource "openstack_compute_instance_v2" "martenson-test" {
  name            = "martenson-test"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.small"
  key_pair        = "martenson"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "martenson-test" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "martenson-test.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.martenson-test.access_ip_v4}"]
}

resource "openstack_compute_instance_v2" "helena-test" {
  name            = "helena-test"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "openstack_compute_instance_v2" "jwolff-test" {
  name            = "jwolff-test"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "c.c40m1000"
  key_pair        = "jwolff"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "jwolff-test-data" {
  name        = "jwolff-test"
  description = "Data volume for test"
  size        = 20
}

resource "openstack_compute_volume_attach_v2" "jwolff-test-va" {
  instance_id = "${openstack_compute_instance_v2.jwolff-test.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.jwolff-test-data.id}"
}