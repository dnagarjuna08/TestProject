UPDATE trn_issuebtn
SET end_time = GETDATE()
WHERE trn_issueBtn_ID = :trn_issueBtn_ID;