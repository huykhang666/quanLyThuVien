CREATE TABLE Librarians (
    librarianID INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(200) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(15) CHECK(phoneNumber NOT LIKE '%[^0-9]%'),
    position NVARCHAR(100),
    workingStatus NVARCHAR(50) DEFAULT N'Đang làm việc'
    CHECK(workingStatus IN (N'Đang làm việc', N'Nghỉ việc'))
);

CREATE TABLE Departments (
    deptID INT PRIMARY KEY IDENTITY(1,1),
    deptName NVARCHAR(100) NOT NULL UNIQUE,
    officePhone VARCHAR(15) CHECK(officePhone NOT LIKE '%[^0-9]%')
);

CREATE TABLE ReaderTypes (
    typeID INT PRIMARY KEY IDENTITY(1,1),
    typeName NVARCHAR(50) NOT NULL UNIQUE,
    maxBooks INT NOT NULL CHECK(maxBooks > 0),
    limitDays INT NOT NULL CHECK(limitDays > 0)
);

CREATE TABLE Readers (
    readerID INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(200) NOT NULL,
    birthDate DATE CHECK(birthDate <= GETDATE()),
    gender NVARCHAR(10) CHECK(gender IN (N'Nam', N'Nữ')),
    address NVARCHAR(255),
    phoneNumber VARCHAR(15) CHECK(phoneNumber NOT LIKE '%[^0-9]%'),
    email VARCHAR(100) UNIQUE,
    typeID INT NOT NULL,
    deptID INT NOT NULL,
    FOREIGN KEY (typeID) REFERENCES ReaderTypes(typeID) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (deptID) REFERENCES Departments(deptID) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE LibraryCards (
    cardID INT PRIMARY KEY IDENTITY(1,1),
    issueDate DATE DEFAULT GETDATE(),
    expiryDate DATE NOT NULL,
    status NVARCHAR(20) DEFAULT N'Kích hoạt' CHECK(status IN (N'Kích hoạt', N'Khóa')),
    readerID INT NOT NULL UNIQUE,
    CHECK(expiryDate > issueDate),
    FOREIGN KEY (readerID) REFERENCES Readers(readerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Categories (
    categoryID INT PRIMARY KEY IDENTITY(1,1),
    categoryName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Authors (
    authorID INT PRIMARY KEY IDENTITY(1,1),
    authorName NVARCHAR(200) NOT NULL,
    biography NVARCHAR(MAX)
);

CREATE TABLE Publishers (
    publisherID INT PRIMARY KEY IDENTITY(1,1),
    publisherName NVARCHAR(200) NOT NULL,
    address NVARCHAR(255),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE BookTitles (
    titleID INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publicationYear INT CHECK(publicationYear <= YEAR(GETDATE())),
    categoryID INT NOT NULL,
    publisherID INT NOT NULL,
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) 
    ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (publisherID) REFERENCES Publishers(publisherID) 
    ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE BookAuthors (
    titleID INT,
    authorID INT,
    PRIMARY KEY(titleID, authorID),
    FOREIGN KEY(titleID) REFERENCES BookTitles(titleID) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(authorID) REFERENCES Authors(authorID) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Libraries (
    libraryID INT PRIMARY KEY IDENTITY(1,1),
    libraryName NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    phoneNumber VARCHAR(15) CHECK(phoneNumber NOT LIKE '%[^0-9]%')
);

CREATE TABLE Shelves (
    shelfID INT PRIMARY KEY IDENTITY(1,1),
    shelfName NVARCHAR(50),
    floor INT CHECK(floor >= 1),
    libraryID INT NOT NULL,
    FOREIGN KEY(libraryID) REFERENCES Libraries(libraryID) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Bảng đã được cập nhật theo image_b08d18.png
CREATE TABLE BookLocations (
    locationID INT PRIMARY KEY IDENTITY(1,1),
    slotNumber INT CHECK(slotNumber > 0),
    description NVARCHAR(255), -- Đã thêm theo sơ đồ
    shelfID INT NOT NULL,
    FOREIGN KEY(shelfID) REFERENCES Shelves(shelfID) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE BookCopies (
    copyID INT PRIMARY KEY IDENTITY(1,1),
    status NVARCHAR(50) DEFAULT N'Sẵn có' 
    CHECK(status IN (N'Sẵn có', N'Đang mượn', N'Hỏng', N'Mất')),
    price DECIMAL(18,2) CHECK(price >= 0),
    titleID INT NOT NULL,
    locationID INT NOT NULL,
    FOREIGN KEY(titleID) REFERENCES BookTitles(titleID) 
    ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY(locationID) REFERENCES BookLocations(locationID) 
    ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE InventoryChecks (
    checkID INT PRIMARY KEY IDENTITY(1,1),
    checkDate DATE DEFAULT GETDATE(),
    notes NVARCHAR(MAX),
    librarianID INT NOT NULL,
    FOREIGN KEY(librarianID) REFERENCES Librarians(librarianID)
);

CREATE TABLE InventoryCheckDetails (
    checkDetailID INT PRIMARY KEY IDENTITY(1,1),
    statusFound NVARCHAR(50),
    checkID INT NOT NULL,
    copyID INT NOT NULL,
    FOREIGN KEY(checkID) REFERENCES InventoryChecks(checkID) 
    ON DELETE CASCADE,
    FOREIGN KEY(copyID) REFERENCES BookCopies(copyID)
);

CREATE TABLE Suppliers (
    supplierID INT PRIMARY KEY IDENTITY(1,1),
    supplierName NVARCHAR(200) NOT NULL,
    address NVARCHAR(255),
    phoneNumber VARCHAR(15) CHECK(phoneNumber NOT LIKE '%[^0-9]%')
);

CREATE TABLE BookConditions (
    conditionID INT PRIMARY KEY IDENTITY(1,1),
    conditionName NVARCHAR(50) NOT NULL
    CHECK(conditionName IN (N'Mới', N'Cũ', N'Hư hỏng nhẹ'))
);

CREATE TABLE ImportReceipts (
    importID INT PRIMARY KEY IDENTITY(1,1),
    importDate DATE DEFAULT GETDATE(),
    totalAmount DECIMAL(18,2) CHECK(totalAmount >= 0),
    supplierID INT NOT NULL,
    librarianID INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY(supplierID) REFERENCES Suppliers(supplierID),
    FOREIGN KEY(librarianID) REFERENCES Librarians(librarianID)
);

CREATE TABLE ImportDetails (
    importDetailID INT PRIMARY KEY IDENTITY(1,1),
    quantity INT NOT NULL CHECK(quantity > 0),
    unitPrice DECIMAL(18,2) CHECK(unitPrice >= 0),
    importID INT NOT NULL,
    titleID INT NOT NULL,
    conditionID INT NOT NULL,
    FOREIGN KEY(importID) REFERENCES ImportReceipts(importID) 
    ON DELETE CASCADE,
    FOREIGN KEY(titleID) REFERENCES BookTitles(titleID),
    FOREIGN KEY(conditionID) REFERENCES BookConditions(conditionID)
);

CREATE TABLE BorrowSlips (
    borrowID INT PRIMARY KEY IDENTITY(1,1),
    borrowDate DATE DEFAULT GETDATE(),
    dueDate DATE NOT NULL,
    status NVARCHAR(50),
    readerID INT NOT NULL,
    librarianID INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    CHECK(dueDate >= borrowDate),
    FOREIGN KEY(readerID) REFERENCES Readers(readerID),
    FOREIGN KEY(librarianID) REFERENCES Librarians(librarianID)
);

CREATE TABLE BorrowDetails (
    borrowDetailID INT PRIMARY KEY IDENTITY(1,1),
    actualReturnDate DATE,
    note NVARCHAR(MAX),
    borrowID INT NOT NULL,
    copyID INT NOT NULL,
    FOREIGN KEY(borrowID) REFERENCES BorrowSlips(borrowID) 
    ON DELETE CASCADE,
    FOREIGN KEY(copyID) REFERENCES BookCopies(copyID)
);

CREATE TABLE ReturnSlips (
    returnID INT PRIMARY KEY IDENTITY(1,1),
    returnDate DATE DEFAULT GETDATE(),
    totalFine DECIMAL(18,2) DEFAULT 0 CHECK(totalFine >= 0),
    borrowID INT NOT NULL,
    librarianID INT NOT NULL,
    FOREIGN KEY(borrowID) REFERENCES BorrowSlips(borrowID),
    FOREIGN KEY(librarianID) REFERENCES Librarians(librarianID)
);

CREATE TABLE ReturnDetails (
    returnDetailID INT PRIMARY KEY IDENTITY(1,1),
    returnCondition NVARCHAR(255),
    returnID INT NOT NULL,
    borrowDetailID INT NOT NULL,
    FOREIGN KEY(returnID) REFERENCES ReturnSlips(returnID)
    ON DELETE CASCADE,
    FOREIGN KEY(borrowDetailID) REFERENCES BorrowDetails(borrowDetailID)
);

CREATE TABLE BorrowExtensions (
    extensionID INT PRIMARY KEY IDENTITY(1,1),
    extensionDate DATE DEFAULT GETDATE(),
    newDueDate DATE NOT NULL,
    reason NVARCHAR(MAX),
    borrowDetailID INT NOT NULL,
    CHECK(newDueDate > extensionDate),
    FOREIGN KEY(borrowDetailID) REFERENCES BorrowDetails(borrowDetailID)
);

CREATE TABLE LostBookReports (
    lostReportID INT PRIMARY KEY IDENTITY(1,1),
    reportDate DATE DEFAULT GETDATE(),
    compensationFee DECIMAL(18,2) CHECK(compensationFee >= 0),
    borrowDetailID INT NOT NULL,
    librarianID INT NOT NULL,
    FOREIGN KEY(borrowDetailID) REFERENCES BorrowDetails(borrowDetailID),
    FOREIGN KEY(librarianID) REFERENCES Librarians(librarianID)
);

CREATE TABLE Fines (
    fineID INT PRIMARY KEY IDENTITY(1,1),
    amount DECIMAL(18,2) CHECK(amount >= 0),
    paymentDate DATE,
    reason NVARCHAR(255),
    returnDetailID INT NULL,
    lostReportID INT NULL,
    CHECK(returnDetailID IS NOT NULL OR lostReportID IS NOT NULL),
    FOREIGN KEY(returnDetailID) REFERENCES ReturnDetails(returnDetailID),
    FOREIGN KEY(lostReportID) REFERENCES LostBookReports(lostReportID)
);

CREATE TABLE BorrowingRules (
    ruleID INT PRIMARY KEY IDENTITY(1,1),
    maxBooks INT CHECK(maxBooks > 0),
    maxDays INT CHECK(maxDays > 0),
    typeID INT NOT NULL UNIQUE,
    FOREIGN KEY(typeID) REFERENCES ReaderTypes(typeID)
);
GO