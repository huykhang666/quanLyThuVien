CREATE TABLE Librarians (
    librarianID INT PRIMARY KEY IDENTITY(1,1),

    fullName NVARCHAR(200) NOT NULL,

    username VARCHAR(50) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    phoneNumber VARCHAR(15)
    CHECK(phoneNumber NOT LIKE '%[^0-9]%'),

    position NVARCHAR(100),

    workingStatus NVARCHAR(50)
    DEFAULT N'Đang làm việc'
    CHECK(workingStatus IN (
        N'Đang làm việc',
        N'Nghỉ việc'
    )),
);

CREATE TABLE Departments (
    deptID INT PRIMARY KEY IDENTITY(1,1),

    deptName NVARCHAR(100) NOT NULL UNIQUE,

    officePhone VARCHAR(15)
    CHECK(officePhone NOT LIKE '%[^0-9]%')
);

CREATE TABLE ReaderTypes (
    typeID INT PRIMARY KEY IDENTITY(1,1),

    typeName NVARCHAR(50) NOT NULL UNIQUE,

    maxBooks INT NOT NULL
    CHECK(maxBooks > 0),

    limitDays INT NOT NULL
    CHECK(limitDays > 0)
);

CREATE TABLE Readers (
    readerID INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(200) NOT NULL,
    birthDate DATE
    CHECK(birthDate <= GETDATE()),
    gender NVARCHAR(10)
    CHECK(gender IN (
        N'Nam',
        N'Nữ'
    )),
    address NVARCHAR(255),
    phoneNumber VARCHAR(15)
    CHECK(phoneNumber NOT LIKE '%[^0-9]%'),
    email VARCHAR(100) UNIQUE,
    typeID INT NOT NULL,
    deptID INT NOT NULL,
    FOREIGN KEY (typeID)
    REFERENCES ReaderTypes(typeID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY (deptID)
    REFERENCES Departments(deptID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE LibraryCards (
    cardID INT PRIMARY KEY IDENTITY(1,1),
    issueDate DATE DEFAULT GETDATE(),
    expiryDate DATE NOT NULL,
    status NVARCHAR(20)
    DEFAULT N'Kích hoạt'
    CHECK(status IN (
        N'Kích hoạt',
        N'Khóa'
    )),
    readerID INT NOT NULL UNIQUE,
    CHECK(expiryDate > issueDate),
    FOREIGN KEY (readerID)
    REFERENCES Readers(readerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
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

    publicationYear INT
    CHECK(publicationYear <= YEAR(GETDATE())),

    categoryID INT NOT NULL,

    publisherID INT NOT NULL,

    FOREIGN KEY (categoryID)
    REFERENCES Categories(categoryID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

    FOREIGN KEY (publisherID)
    REFERENCES Publishers(publisherID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE BookAuthors (
    titleID INT,

    authorID INT,

    PRIMARY KEY(titleID, authorID),

    FOREIGN KEY(titleID)
    REFERENCES BookTitles(titleID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY(authorID)
    REFERENCES Authors(authorID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Libraries (
    libraryID INT PRIMARY KEY IDENTITY(1,1),

    libraryName NVARCHAR(100) NOT NULL,

    address NVARCHAR(255),

    phoneNumber VARCHAR(15)
    CHECK(phoneNumber NOT LIKE '%[^0-9]%')
);

CREATE TABLE Shelves (
    shelfID INT PRIMARY KEY IDENTITY(1,1),

    shelfName NVARCHAR(50),

    floor INT
    CHECK(floor >= 1),

    libraryID INT NOT NULL,

    FOREIGN KEY(libraryID)
    REFERENCES Libraries(libraryID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);
CREATE TABLE BookLocations (
    locationID INT PRIMARY KEY IDENTITY(1,1),

    slotNumber INT
    CHECK(slotNumber > 0),

    binNumber INT
    CHECK(binNumber > 0),

    shelfID INT NOT NULL,

    FOREIGN KEY(shelfID)
    REFERENCES Shelves(shelfID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE BookCopies (
    copyID INT PRIMARY KEY IDENTITY(1,1),

    status NVARCHAR(50)
    DEFAULT N'Sẵn có'
    CHECK(status IN (
        N'Sẵn có',
        N'Đang mượn',
        N'Hỏng',
        N'Mất'
    )),

    price DECIMAL(18,2)
    CHECK(price >= 0),
    titleID INT NOT NULL,
    locationID INT NOT NULL,
    FOREIGN KEY(titleID)
    REFERENCES BookTitles(titleID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    FOREIGN KEY(locationID)
    REFERENCES BookLocations(locationID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE InventoryChecks (
    checkID INT PRIMARY KEY IDENTITY(1,1),

    checkDate DATE DEFAULT GETDATE(),

    notes NVARCHAR(MAX),

    librarianID INT NOT NULL,

    FOREIGN KEY(librarianID)
    REFERENCES Librarians(librarianID)
);

CREATE TABLE InventoryCheckDetails (
    checkDetailID INT PRIMARY KEY IDENTITY(1,1),

    statusFound NVARCHAR(50),

    checkID INT NOT NULL,

    copyID INT NOT NULL,

    FOREIGN KEY(checkID)
    REFERENCES InventoryChecks(checkID)
    ON DELETE CASCADE,

    FOREIGN KEY(copyID)
    REFERENCES BookCopies(copyID)
);



