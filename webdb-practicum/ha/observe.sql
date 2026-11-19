SELECT pg_is_in_recovery();
-- On primary:
SELECT application_name, state, sync_state, sent_lsn, flush_lsn, replay_lsn,
       pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS replay_gap_bytes
FROM pg_stat_replication;
-- On standby:
SELECT status, written_lsn, flushed_lsn, latest_end_lsn FROM pg_stat_wal_receiver;
SELECT pg_is_wal_replay_paused(), pg_last_wal_replay_lsn();
