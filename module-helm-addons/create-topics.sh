# block until kafka is reachable
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --list

kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic payment-request --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic payment-response --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic restaurant-approval-request --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic restaurant-approval-response --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic customer --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic debezium.order.payment_outbox --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic debezium.order.restaurant_outbox --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic debezium.payment.order_outbox --delete --if-exists
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --topic debezium.restaurant.order_outbox --delete --if-exists

echo -e 'Creating kafka topics'
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic payment-request --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic payment-response --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic restaurant-approval-request --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic restaurant-approval-response --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic customer --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic debezium.order.payment_outbox --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic debezium.order.restaurant_outbox --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic debezium.payment.order_outbox --replication-factor 3 --partitions 3
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --create --if-not-exists --topic debezium.restaurant.order_outbox --replication-factor 3 --partitions 3

echo -e 'Successfully created the following topics:'
kafka-topics --bootstrap-server bitnami-kafka-headless:9092 --list