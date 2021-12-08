DROP TABLE IF EXISTS obc;

DROP TABLE IF EXISTS eps;

DROP TABLE IF EXISTS mde;

DROP TABLE IF EXISTS crp;

DROP TABLE IF EXISTS acs;

DROP TABLE IF EXISTS telemetry;

CREATE TABLE telemetry (
                           downlink_id INT NOT NULL IDENTITY (0, 1),
                           downlink_timestamp DATETIME,
                           pass_number INT NOT NULL,
                           PRIMARY KEY (downlink_id)
);

CREATE TABLE obc (
                     downlink_id INT NOT NULL,
                     schedule_failures INT,
                     PRIMARY KEY (downlink_id),
                     FOREIGN KEY (downlink_id) REFERENCES telemetry (downlink_id)
);

CREATE TABLE acs (
                     downlink_id INT NOT NULL,
                     x_pos INT,
                     y_pos INT,
                     z_pos INT,
                     PRIMARY KEY (downlink_id),
                     FOREIGN KEY (downlink_id) REFERENCES telemetry (downlink_id)
);

CREATE TABLE eps (
                     downlink_id INT NOT NULL,
                     avg_bat_voltage DECIMAL(5, 3),
                     brownouts INT,
                     charge_time_min DECIMAL(5, 2),
                     peak_charge_power DECIMAL(5, 2),
                     PRIMARY KEY (downlink_id),
                     FOREIGN KEY (downlink_id) REFERENCES telemetry (downlink_id)
);

CREATE TABLE mde (
                     downlink_id INT NOT NULL,
                     chip_id INT,
                     bits_flipped INT,
                     gps_lat DECIMAL(18, 15),
                     gps_long DECIMAL(18, 15),
                     PRIMARY KEY (downlink_id),
                     FOREIGN KEY (downlink_id) REFERENCES telemetry (downlink_id)
);

CREATE TABLE crp (
                     downlink_id INT NOT NULL,
                     image_data INT,
                     gps_lat DECIMAL(18, 15),
                     gps_long DECIMAL(18, 15),
                     PRIMARY KEY (downlink_id),
                     FOREIGN KEY (downlink_id) REFERENCES telemetry (downlink_id)
);