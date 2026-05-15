SELECT BT.title, BC.copyID, BC.status, BC.price
FROM BookTitles BT
JOIN BookCopies BC ON BT.titleID = BC.titleID;

SELECT RT.typeName, R.fullName, R.email, R.phoneNumber
FROM Readers R
JOIN ReaderTypes RT ON R.typeID = RT.typeID
ORDER BY RT.typeName;

SELECT status, COUNT(*) AS SoLuong
FROM BookCopies
GROUP BY status;

SELECT BS.borrowID, R.fullName AS ReaderName, BT.title, BS.borrowDate, BS.dueDate, BS.status
FROM BorrowSlips BS
JOIN Readers R ON BS.readerID = R.readerID
JOIN BorrowDetails BD ON BS.borrowID = BD.borrowID
JOIN BookCopies BC ON BD.copyID = BC.copyID
JOIN BookTitles BT ON BC.titleID = BT.titleID;