puts PgHashFunc::VERSION
puts PgHashFunc::Hasher::HASH_PARTITION_SEED
puts PgHashFunc::Hasher::PARTITION_MAGIC_CONSTANT
puts PgHashFunc.calculate_partition_index_bigint(value: 1, num_partitions: 4)
puts PgHashFunc.calculate_partition_index_bigint(value: 42, num_partitions: 4)
puts PgHashFunc.calculate_partition_index_bigint(value: -1, num_partitions: 4)
puts PgHashFunc.calculate_partition_index_int4(value: 1, num_partitions: 4)
puts PgHashFunc.calculate_partition_index_int4(value: 100, num_partitions: 8)
puts PgHashFunc.hashint8extended(value: 0)
puts PgHashFunc.hashint8extended(value: 1)
