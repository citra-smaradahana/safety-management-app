CREATE TABLE IF NOT EXISTS take_5 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  tanggal date NOT NULL,
  site text NOT NULL,
  detail_lokasi text NOT NULL,
  judul_pekerjaan text NOT NULL,
  potensi_bahaya text NOT NULL,
  q1 boolean NOT NULL,
  q2 boolean NOT NULL,
  q3 boolean NOT NULL,
  q4 boolean NOT NULL,
  aman text NOT NULL,
  status text NOT NULL,
  bukti_perbaikan text,
  created_at timestamp with time zone DEFAULT now()
); 