CREATE TABLE product (
    pid                   INTEGER NOT NULL,
    manufacturer          VARCHAR(20),
    model                 VARCHAR(20),
    release_date          DATE,
    retail_price          FLOAT,
    qty_in_stock          INTEGER,
  PRIMARY KEY (pid)
);

CREATE TABLE camera (
    pid                   INTEGER NOT NULL,
    pixel_num             FLOAT,
    sensor_size           FLOAT,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE finder (
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (fid)
);

-- Electronic viewfinder
CREATE TABLE finder_ev (
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (fid),
  FOREIGN KEY (fid) REFERENCES finder(fid)
);

-- Optical viewfinder
CREATE TABLE finder_ov (
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (fid),
  FOREIGN KEY (fid) REFERENCES finder(fid)
);

-- "Through the lens" optical viewfinder
CREATE TABLE finder_tv (
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (fid),
  FOREIGN KEY (fid) REFERENCES finder(fid)
);

-- Optical rangefinder
CREATE TABLE finder_or (
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (fid),
  FOREIGN KEY (fid) REFERENCES finder(fid)
);

CREATE TABLE camera_finder (
    camera_id             INTEGER NOT NULL,
    fid                   INTEGER NOT NULL,
  PRIMARY KEY (camera_id, fid),
  FOREIGN KEY (camera_id) REFERENCES camera(pid),
  FOREIGN KEY (fid) REFERENCES finder(fid)
);

CREATE TABLE unreplacable_lens_cam (
    pid                   INTEGER NOT NULL,
    focal_len_min         FLOAT,
    focal_len_max         FLOAT,
    aperture_min          FLOAT,
    aperture_max          FLOAT,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES camera(pid)
);

CREATE TABLE replacable_lens_cam (
    pid                   INTEGER NOT NULL,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES camera(pid)
);

CREATE TABLE lens (
    pid                   INTEGER NOT NULL,
    focal_len_min         FLOAT,
    focal_len_max         FLOAT,
    aperture_min          FLOAT,
    aperture_max          FLOAT,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE prime_lens (
    pid                   INTEGER NOT NULL,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES lens(pid)
);

CREATE TABLE camera_lens (
    camera_id             INTEGER NOT NULL,
    lens_id               INTEGER NOT NULL,
  PRIMARY KEY (camera_id, lens_id),
  FOREIGN KEY (camera_id) REFERENCES replacable_lens_cam(pid),
  FOREIGN KEY (lens_id) REFERENCES lens(pid)
);

CREATE TABLE customer (
    cid                   INTEGER NOT NULL,
    name                  VARCHAR(20),
    email                 VARCHAR(20),
    shipping_address      VARCHAR(50),
  PRIMARY KEY (cid)
);

CREATE TABLE online_customer (
    cid                   INTEGER NOT NULL,
  PRIMARY KEY (cid),
  FOREIGN KEY (cid) REFERENCES customer(cid)
);

CREATE TABLE domestic_customer (
    cid                   INTEGER NOT NULL,
  PRIMARY KEY (cid),
  FOREIGN KEY (cid) REFERENCES customer(cid)
);

CREATE TABLE purchase_order (
    cid                   INTEGER NOT NULL,
    pid                   INTEGER NOT NULL,
    selling_price         FLOAT,
    outstanding           BOOLEAN,
  FOREIGN KEY (cid) REFERENCES customer(cid),
  FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE evaluation (
    cid                   INTEGER NOT NULL,
    pid                   INTEGER NOT NULL,
    score                 INTEGER NOT NULL,
    comment               VARCHAR(100),
  PRIMARY KEY (cid, pid),
  FOREIGN KEY (cid) REFERENCES customer(cid),
  FOREIGN KEY (pid) REFERENCES product(pid)
);
