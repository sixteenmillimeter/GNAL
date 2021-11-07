CREATE TABLE IF NOT EXISTS renders (
	time INTEGER PRIMARY KEY,
	commit_id TEXT,
	source TEXT,
	model TEXT,
	stl TEXT,
	stl_size INTEGER,
	facets INTEGER,
	volume REAL,
	x REAL,
	y REAL,
	z REAL,
	render_time INTEGER,
	source_hash TEXT,
	stl_hash TEXT,
	openscad TEXT,
	cpu TEXT
);