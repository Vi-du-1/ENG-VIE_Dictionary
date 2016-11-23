create database ENG_VIE_DICTIONARY;
use ENG_VIE_DICTIONARY;

create table TaiKhoan (Users varchar(50) PRIMARY KEY,
						Passwd varchar(50) NOT NULL,
						NgaySinh date NOT NULL,
						SDT varchar(15),
						Email varchar(50));

create table User_PhatAm (ID_UserPhatAm char(10) PRIMARY KEY,
							ThoiGianPhatAm datetime NOT NULL,
							Users varchar(50) NOT NULL,
							ID_W char(10) NOT NULL,
							Link_UserPhatAm varchar(50) NOT NULL);

create table Dictionary (ID_W char(10) PRIMARY KEY,
							Word varchar(20) NOT NULL,
							Pronun char (20) NOT NULL,
							Mean nvarchar (50) NOT NULL,
							Link varchar(50) NOT NULL);

create table Login (ID_Login char(10) PRIMARY KEY,
					Users varchar(50) NOT NULL,
					TGLogin datetime NOT NULL);

create table User_Vocabulary (ID_Voca char(10) PRIMARY KEY,
								Voca varchar(20) NOT NULL,
								Mean_Voca nvarchar(50) NOT NULL,
								Date_Voca datetime NOT NULL,
								Users varchar(50) NOT NULL,
								ID_W char(10) NOT NULL);
								
create table PhatAm (ID_PhatAm char(10) PRIMARY KEY,
						ID_W char(10) NOT NULL,
						Link_PhatAm varchar(50) NOT NULL);

create table DeXuatChinhSua (ID_DXCS char(10) PRIMARY KEY,
								ThoiGian datetime NOT NULL,
								NoiDungDeXuat nvarchar(500) NOT NULL,
								Users varchar(50) NOT NULL);

create table ThangTrinhDo (ID_ThangTrinhDo char(10) PRIMARY KEY,
							ThoiGian datetime NOT NULL,
							TrinhDo nvarchar(30) NOT NULL,
							Users varchar(50) NOT NULL);

create table TraCuuThongTin (ID_TraCuuThongTin char(10) PRIMARY KEY,
								NoiDung nvarchar(500)NOT NULL);

create table PhanHoi (ID_PhanHoi char(10) PRIMARY KEY,
						NoiDung nvarchar(500)NOT NULL);

create table TaiLieu (ID_TaiLieu char(10) PRIMARY KEY,
						TenTaiLieu nvarchar(30) NOT NULL,
						DinhDang varchar(4) NOT NULL);

create table Grammar (ID_Gr char(10) PRIMARY KEY, 
						Name_Gr varchar(30) NOT NULL,
						Grammar nvarchar(500)NOT NULL);

create table TroGiup (ID_TroGiup char(10) PRIMARY KEY,
						NoiDungTroGiup nvarchar(500)NOT NULL);

create table BaiHoc (ID_BaiHoc char(10) PRIMARY KEY,
						NoiDungBaiHoc nvarchar(500)NOT NULL);

create table Test (ID_Test uniqueidentifier default newID() PRIMARY KEY,
					NoiDung1 nvarchar(50),
					NoiDung2 nvarchar(50));

insert into Test(NoiDung1, NoiDung2) values (N'abaca', N'adfsdfa');
insert into Test(NoiDung1, NoiDung2) values (N'ádfea', N'adfádfasfsdfa');

--Khóa ngoại tham chiếu đến bảng Users:
ALTER TABLE User_PhatAm ADD CONSTRAINT KN_User_PhatAm_User FOREIGN KEY (Users) REFERENCES TaiKhoan (Users);
ALTER TABLE Login ADD CONSTRAINT KN_Login_User FOREIGN KEY (Users) REFERENCES TaiKhoan (Users);
ALTER TABLE User_Vocabulary ADD CONSTRAINT KN_User_Vocabulary_User FOREIGN KEY (Users) REFERENCES TaiKhoan (Users);
ALTER TABLE DeXuatChinhSua ADD CONSTRAINT KN_DeXuatChinhSua_User FOREIGN KEY (Users) REFERENCES TaiKhoan (Users);
ALTER TABLE ThangTrinhDo ADD CONSTRAINT KN_ThangTrinhDo_User FOREIGN KEY (Users) REFERENCES TaiKhoan (Users);

--Khóa ngoại tham chiếu đến bảng Dictionary:
ALTER TABLE User_PhatAm ADD CONSTRAINT KN_User_PhatAm_Dictionary FOREIGN KEY (ID_W) REFERENCES Dictionary (ID_W);
ALTER TABLE User_Vocabulary ADD CONSTRAINT KN_User_Vocabulary_Dictionary FOREIGN KEY (ID_W) REFERENCES Dictionary (ID_W);
ALTER TABLE PhatAm ADD CONSTRAINT KN_PhatAm_Dictionary FOREIGN KEY (ID_W) REFERENCES Dictionary (ID_W);



--TẠO DỮ LIỆU
insert into TaiKhoan(Users, Passwd, NgaySinh, SDT, Email) values('tuananh', '123','1996-04-09','0962126964','nguyentuananh9496@gmail.com');

insert into Dictionary(ID_W, Word, Pronun, Mean, Link) values ('W002', 'House', '/haos/', N'Ngôi nhà', 'OIJLKAJSLKFJS');


--insert into Dictionary(ID_W, Word, Pronun, Mean, Link) values ()


--TẠO TRIGGERS
/*
create database triggertudong
use triggertudong
CREATE TABLE SinhVien
(
MaSV VARCHAR(100) primary key,
HoTen NVARCHAR(50),
QueQuan NVARCHAR(50)
)
GO

IF OBJECT_ID ('IDTuDong1','TR') IS NOT NULL DROP TRIGGER IDTuDong1; 
go
CREATE TRIGGER IDTuDong1
ON SinhVien 
INSTEAD OF INSERT 
AS 
DECLARE @ma VARCHAR(100),@so VARCHAR(100),@HoTen NVARCHAR(50),@QueQuan NVARCHAR(100)
SELECT @ma='MA',@so=rand(),@HoTen=HoTen,@QueQuan=QueQuan
FROM INSERTED
INSERT INTO SinhVien VALUES (@ma+@so,@HoTen,@QueQuan)

GO

INSERT INTO SinhVien (HoTen,QueQuan) VALUES ('Tuan Anh','Nghe An')

*/

--Không cho xóa từ trong từ điển
IF OBJECT_ID ('CANNOT_DELETE_DICTIONARY','TR') IS NOT NULL DROP TRIGGER CANNOT_DELETE_DICTIONARY; 
go
CREATE TRIGGER CANNOT_DELETE_DICTIONARY
ON Dictionary
FOR DELETE
AS
BEGIN
   RAISERROR ('Không thể xóa từ ', 16, 1)
   ROLLBACK TRAN

END
GO

DELETE FROM Dictionary WHERE ID_W='W002'


--Không cho thêm trùng từ trong bảng PhatAm
IF OBJECT_ID ('ThemTrungTu_PhatAm','TR') IS NOT NULL DROP TRIGGER ThemTrungTu_PhatAm; 
go
CREATE TRIGGER ThemTrungTu_PhatAm
ON PhatAm
after insert, update
AS
BEGIN
	if update(ID_PhatAm)
	begin
		DECLARE @ID_W char(10), @count int
		SET @ID_W = (select ID_W from inserted)
		set @count = (select COUNT(*) from PhatAm where @ID_W = ID_W)
		if(@count > 1)
		begin
			raiserror ('Trùng từ !', 16, 1);
			rollback
		end
	end
END
GO

insert into PhatAm(ID_PhatAm, ID_W, Link_PhatAm) values ('PA008', 'W003', 'sdfa');


--Xóa tài khoản sẽ xóa luôn thông tin đăng nhập của tài khoản đó
IF OBJECT_ID ('XoaTaiKhoan','TR') IS NOT NULL DROP TRIGGER XoaTaiKhoan; 
go
create trigger XoaTaiKhoan on TaiKhoan
instead of delete
as
begin
	declare @users char (10) = (select users from deleted)
	delete from Login where Login.Users = @users
end

delete from TaiKhoan where Users = 'u1';


--Cập nhật nghĩa của từ trong bảng Dictionary thì sẽ cập nhật luôn trong User_Vocabulary
IF OBJECT_ID ('CapNhatNghiaCuaTu_Dictionary','TR') IS NOT NULL DROP TRIGGER CapNhatNghiaCuaTu_Dictionary; 
go
create trigger CapNhatNghiaCuaTu_Dictionary
on Dictionary
after update
as
BEGIN
	DECLARE @Mean nvarchar(50)
	set @Mean = (Select Mean from inserted)
	if update(Mean)
	BEGIN
		update User_Vocabulary set Mean_Voca = (select Dictionary.Mean
												from User_Vocabulary, Dictionary
												where Dictionary.ID_W = User_Vocabulary.ID_W)
	END
END
GO

UPDATE Dictionary
set Mean = N'Điện thoại di động'
where Word = 'Cellphone'


--Phát sinh mã tự động cho từ điển
IF OBJECT_ID ('PhatSinhMaTuDong_Dictionary','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_Dictionary; 
go
create trigger PhatSinhMaTuDong_Dictionary
on Dictionary
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_W char(10)
	set @ID_W = (select top 1 ID_W from Dictionary order by ID_W desc)
	if @ID_W is null
	BEGIN		
		Set @ID_W = 'W000000001'

	END
	else
		BEGIN
			set @ID_W = Convert(int, SUBSTRING(@ID_W, 2, 9)) + 1
			if len(@ID_W) = 1
			BEGIN
				set @ID_W = 'W00000000' + @ID_W
			END
			else if len(@ID_W) = 2
			BEGIN
				set @ID_W = 'W0000000' + @ID_W
			END
			else if len(@ID_W) = 3
			BEGIN
				set @ID_W = 'W000000' + @ID_W
			END
			else if len(@ID_W) = 4
			BEGIN
				set @ID_W = 'W00000' + @ID_W
			END
			else if len(@ID_W) = 5
			BEGIN
				set @ID_W = 'W0000' + @ID_W
			END
			else if len(@ID_W) = 6
			BEGIN
				set @ID_W = 'W000' + @ID_W
			END
			else if len(@ID_W) = 7
			BEGIN
				set @ID_W = 'W00' + @ID_W
			END
			else if len(@ID_W) = 8
			BEGIN
				set @ID_W = 'W0' + @ID_W
			END
			else if len(@ID_W) = 9
			BEGIN
				set @ID_W = 'W' + @ID_W
			END
			
		END
		insert into Dictionary(ID_W, Word, Pronun, Mean, Link) values(@ID_W, (Select Word from inserted), 
																				(Select Pronun from inserted),
																				(Select Mean from inserted),
																				(Select Link from inserted))
		print 'Insert Suscessfull ID_W: ' + @ID_W
END
GO

insert into Dictionary (Word, Pronun, Mean, Link) values ('Right', '/raIt/', N'Đúng', 'fefefa');