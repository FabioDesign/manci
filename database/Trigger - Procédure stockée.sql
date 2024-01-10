DROP TRIGGER IF EXISTS insert_dev;
DELIMITER |
CREATE TRIGGER insert_dev AFTER INSERT
ON proforma FOR EACH ROW
BEGIN
    DECLARE v_sumrem int;
    DECLARE v_sumtva int;
    DECLARE v_devis_id int;
    SELECT devis.id, sum_rem, sum_tva INTO v_devis_id, v_sumrem, v_sumtva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=NEW.devttr_id;
    CALL devis(v_devis_id, v_sumrem, v_sumtva);
END |
DELIMITER ;

DROP TRIGGER if exists update_dev;
DELIMITER |
CREATE TRIGGER update_dev AFTER UPDATE
ON proforma FOR EACH ROW
BEGIN
    DECLARE v_sumrem int;
    DECLARE v_sumtva int;
    DECLARE v_devis_id int;
    SELECT devis.id, sum_rem, sum_tva INTO v_devis_id, v_sumrem, v_sumtva FROM devis, devis_ttr WHERE devis.id=devis_ttr.devis_id AND devis_ttr.id=NEW.devttr_id;
    CALL devis(v_devis_id, v_sumrem, v_sumtva);
END |
DELIMITER ;


DROP PROCEDURE IF EXISTS devis;
DELIMITER |
CREATE PROCEDURE devis(v_devis_id int, v_sumrem int, v_sumtva int)
  BEGIN

    -- Declaration variable
    DECLARE v_ht float;
    DECLARE v_rem float;
    DECLARE v_tva float;
    DECLARE v_ttc float;
    DECLARE v_euro float;
    DECLARE v_value float;
    DECLARE v_total float;

    -- Euro
    SELECT value INTO v_value FROM euros WHERE status = '1';

    -- Total Proforma
    SELECT SUM(total) INTO v_total FROM devis_ttr, proforma WHERE devis_ttr.id=proforma.devttr_id AND devis_id=v_devis_id;

    -- Remise
    SET v_rem = 0;
    SET v_ht = v_total;
    IF v_sumrem != 0 THEN
        SET v_rem = (v_ht * v_sumrem) / 100;
        SET v_total = v_ht - v_rem;
    END IF;

    -- TVA
    SET v_tva = 0;
    SET v_ttc = v_total;
    IF v_sumtva != 0 THEN
        SET v_tva = (v_ttc * v_sumtva) / 100;
        SET v_ttc = v_ttc + v_tva;
    END IF;

    -- Euro
    SET v_euro = v_ttc / v_value;

    -- Update Devis
    UPDATE devis SET mt_rem = v_rem, mt_tva = v_tva, mt_ht = v_ht, mt_ttc = v_ttc, mt_euro = v_euro WHERE id = v_devis_id;

  END;
|
DELIMITER ;

DROP TRIGGER IF EXISTS insert_stat;
DELIMITER |
CREATE TRIGGER insert_stat AFTER INSERT
ON devis FOR EACH ROW
BEGIN
    CALL statistic();
END |
DELIMITER ;

DROP TRIGGER if exists update_dev;
DELIMITER |
CREATE TRIGGER update_dev AFTER UPDATE
ON devis FOR EACH ROW
BEGIN
    CALL statistic();
END |
DELIMITER ;


DROP PROCEDURE IF EXISTS statistic;
DELIMITER |
CREATE PROCEDURE statistic()
  BEGIN

    -- Declaration variable
    DECLARE v_draft int;
    DECLARE v_pending int;
    DECLARE v_approved int;
    DECLARE v_rejected int;
    DECLARE v_validated int;
    DECLARE v_canceled int;
    
    -- Brouillon
    SELECT COUNT(*) INTO v_draft FROM devis WHERE status = '0';

    -- Transmis
    SELECT COUNT(*) INTO v_pending FROM devis WHERE status = '1';

    -- Approuvé
    SELECT COUNT(*) INTO v_approved FROM devis WHERE status = '2';

    -- Rejeté
    SELECT COUNT(*) INTO v_rejected FROM devis WHERE status = '3';

    -- Validé
    SELECT COUNT(*) INTO v_validated FROM devis WHERE status = '4';

    -- Annulé
    SELECT COUNT(*) INTO v_canceled FROM devis WHERE status = '5';

    -- Insertion des données
    INSERT INTO statistic
    (draft, pending, approved, rejected, validated, canceled, status, created_at)
    VALUES
    (v_draft, v_pending, v_approved, v_rejected, v_validated, v_canceled, '1', NOW())
    ON DUPLICATE KEY UPDATE
    status = '1',
    draft = v_draft,
    pending = v_pending,
    rejected = v_rejected,
    canceled = v_canceled,
    approved = v_approved,
    validated = v_validated;

  END;
|
DELIMITER ;