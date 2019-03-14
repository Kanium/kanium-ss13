TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `role_timeTloginsert` AFTER INSERT ON `ss13_role_time` FOR EACH ROW BEGIN INSERT into ss13_role_time_log (ckey, job, delta) VALUES (NEW.ckey, NEW.job, NEW.minutes);\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `role_timeTlogupdate` AFTER UPDATE ON `ss13_role_time` FOR EACH ROW BEGIN INSERT into ss13_role_time_log (ckey, job, delta) VALUES (NEW.CKEY, NEW.job, NEW.minutes-OLD.minutes);\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `role_timeTlogdelete` AFTER DELETE  ON `ss13_role_time` FOR EACH ROW BEGIN INSERT into ss13_role_time_log (ckey, job, delta) VALUES (OLD.ckey, OLD.job, 0-OLD.minutes);\nEND'
sql_modes=1411383296 1411383296 1411383296
definers='root@localhost' 'root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci' 'utf8mb4_general_ci'
db_cl_names='latin1_swedish_ci' 'latin1_swedish_ci' 'latin1_swedish_ci'
created=153179668560 153179668559 153179668561
