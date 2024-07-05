-- Drop foreign key constraints dynamically
DECLARE @constraintName NVARCHAR(200);

-- Drop Vendor table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Vendor') AND referenced_object_id = OBJECT_ID('Users');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Vendor DROP CONSTRAINT ' + @constraintName);
END

-- Drop Users table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Users') AND referenced_object_id = OBJECT_ID('Roles');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Users DROP CONSTRAINT ' + @constraintName);
END

-- Drop Domain table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Domain') AND referenced_object_id = OBJECT_ID('Framework');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Domain DROP CONSTRAINT ' + @constraintName);
END

-- Drop Questionnaire table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Questionnaire') AND referenced_object_id = OBJECT_ID('Vendor');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Questionnaire DROP CONSTRAINT ' + @constraintName);
END

-- Drop Questions table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Questions') AND referenced_object_id = OBJECT_ID('Domain');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Questions DROP CONSTRAINT ' + @constraintName);
END

-- Drop Responses table constraint if it exists
SELECT @constraintName = name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Responses') AND referenced_object_id = OBJECT_ID('Questionnaire');

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Responses DROP CONSTRAINT ' + @constraintName);
END

-- Drop existing tables if they exist
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Framework', 'U') IS NOT NULL DROP TABLE Framework;
IF OBJECT_ID('Domain', 'U') IS NOT NULL DROP TABLE Domain;
IF OBJECT_ID('Vendor', 'U') IS NOT NULL DROP TABLE Vendor;
IF OBJECT_ID('Questionnaire', 'U') IS NOT NULL DROP TABLE Questionnaire;
IF OBJECT_ID('Questions', 'U') IS NOT NULL DROP TABLE Questions;
IF OBJECT_ID('Responses', 'U') IS NOT NULL DROP TABLE Responses;

-- Recreate tables
-- Create Roles table
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    Role VARCHAR(255)
);

-- Create Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    RoleID INT,
    UserName VARCHAR(255),
    Email VARCHAR(255),
    ContactNumber INT,
    Password VARCHAR(255),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Create Framework table
CREATE TABLE Framework (
    FrameworkID INT PRIMARY KEY,
    FrameworkName VARCHAR(255)
);

-- Create Domain table
CREATE TABLE Domain (
    DomainID INT PRIMARY KEY,
    DomainName VARCHAR(255),
    FrameworkID INT,
    FOREIGN KEY (FrameworkID) REFERENCES Framework(FrameworkID)
);

-- Create Vendor table
CREATE TABLE Vendor (
    VendorID INT PRIMARY KEY,
    VendorName VARCHAR(255),
    VendorAddress VARCHAR(255),
    Tier INT,
    UserID INT,
    RegistrationDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create Questionnaire table
CREATE TABLE Questionnaire (
    QuestionnaireID INT PRIMARY KEY,
    VendorID INT,
    CreationDate DATE,
    QuestionnaireTitle VARCHAR(255),
    SubmissionEndDate DATE,
    QuestionData NVARCHAR(MAX),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);

-- Create Questions table
CREATE TABLE Questions (
    QuestionID INT PRIMARY KEY,
    DomainID INT,
    QuestionType NVARCHAR(MAX),
    QuestionText VARCHAR(255),
    HelperText VARCHAR(255),
    FOREIGN KEY (DomainID) REFERENCES Domain(DomainID)
);

-- Create Responses table
CREATE TABLE Responses (
    ResponseID INT PRIMARY KEY,
    QuestionnaireID INT,
    ResponseData NVARCHAR(MAX),
    ResponseDate DATE,
    FOREIGN KEY (QuestionnaireID) REFERENCES Questionnaire(QuestionnaireID)
);
