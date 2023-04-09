CREATE TABLE PEOPLE_AUDIT_LOG (
  id BIGINT NOT NULL,
  dml_type VARCHAR(20) NOT NULL,
  dml_timestamp TIMESTAMP NOT NULL,
  old_row_data JSONB,
  new_row_data JSONB
);

CREATE OR REPLACE FUNCTION audit_people_changes()
RETURNS TRIGGER AS $$
DECLARE
  dml_type VARCHAR(20) := TG_OP;
BEGIN
  IF dml_type = 'DELETE' THEN
    RAISE EXCEPTION 'Операция удаления не разрешена';
  END IF;

  INSERT INTO PEOPLE_AUDIT_LOG (dml_type, old_row_data, new_row_data)
  VALUES (NEW.id, dml_type, to_jsonb(OLD), to_jsonb(NEW));

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER people_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON PEOPLE
FOR EACH ROW
EXECUTE PROCEDURE audit_people_changes();
