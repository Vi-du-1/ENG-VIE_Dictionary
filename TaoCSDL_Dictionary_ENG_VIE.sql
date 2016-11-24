create database ENG_VIE_DICTIONARY;
use ENG_VIE_DICTIONARY;

create table TaiKhoan (Users varchar(50) PRIMARY KEY,
						Passwd varchar(50) NOT NULL,
						NgaySinh date NOT NULL,
						SDT varchar(15) NOT NULL,
						Email varchar(50) NOT NULL,
						ChucVu bit NOT NULL);

create table User_PhatAm (ID_UserPhatAm char(10) PRIMARY KEY,
							ThoiGianPhatAm datetime NOT NULL,
							Users varchar(50) NOT NULL,
							ID_W char(10) NOT NULL,
							Link_UserPhatAm varchar(50) NOT NULL);

create table Dictionary (ID_W char(10) PRIMARY KEY,
							Word varchar(20) NOT NULL,
							Pronun char (20) NOT NULL,
							TuLoai char (10) NOT NULL,
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
						NoiDung nvarchar(500)NOT NULL,
						DaDoc bit NOT NULL);

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


/*
ALTER TABLE User_PhatAm DROP CONSTRAINT KN_User_PhatAm_Dictionary;
ALTER TABLE User_Vocabulary DROP CONSTRAINT KN_User_Vocabulary_Dictionary;
ALTER TABLE PhatAm DROP CONSTRAINT KN_PhatAm_Dictionary;
*/

/*
ALTER TABLE User_PhatAm DROP CONSTRAINT KN_User_PhatAm_User;
ALTER TABLE Login DROP CONSTRAINT KN_Login_User;
ALTER TABLE User_Vocabulary DROP CONSTRAINT KN_User_Vocabulary_User;
ALTER TABLE DeXuatChinhSua DROP CONSTRAINT KN_DeXuatChinhSua_User;
ALTER TABLE ThangTrinhDo DROP CONSTRAINT KN_ThangTrinhDo_User;
*/

--TẠO DỮ LIỆU
insert into TaiKhoan(Users, Passwd, NgaySinh, SDT, Email) values('tuananh', '123','1996-04-09','0962126964','nguyentuananh9496@gmail.com');

insert into Dictionary(ID_W, Word, Pronun, Mean, Link) values ('W002', 'House', '/haos/', N'Ngôi nhà', 'OIJLKAJSLKFJS');

insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values ('PH00000001', N'Đây nội dung phản hồi số 1', 0);
insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values ('PH00000002', N'Đây nội dung phản hồi số 2', 1);
insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values ('PH00000003', N'Đây nội dung phản hồi số 3', 1);
insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values ('PH00000004', N'Đây nội dung phản hồi số 4', 1);
insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values ('PH00000005', N'Đây nội dung phản hồi số 5', 0);


--=========================================== TRIGGER =====================================================

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

--Không cho thêm trùng từ trong bảng User_Vocabulary
IF OBJECT_ID ('ThemTrungTu_User_Vocabulary','TR') IS NOT NULL DROP TRIGGER ThemTrungTu_User_Vocabulary; 
go
CREATE TRIGGER ThemTrungTu_User_Vocabulary
ON User_Vocabulary
after insert, update
AS
BEGIN
	if update(ID_Voca)
	begin
		DECLARE @ID_W char(10), @count int
		SET @ID_W = (select ID_W from inserted)
		set @count = (select COUNT(*) from User_Vocabulary where @ID_W = ID_W)
		if(@count > 1)
		begin
			raiserror ('Trùng từ !', 16, 1);
			rollback
		end
	end
END
GO

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
		insert into Dictionary(ID_W, Word, Pronun, TuLoai, Mean, Link) values(@ID_W, (Select Word from inserted), 
																				(Select Pronun from inserted),
																				(Select TuLoai from inserted),
																				(Select Mean from inserted),
																				(Select Link from inserted))
		print 'Insert Suscessfull ID_W: ' + @ID_W
END
GO

insert into Dictionary (Word, Pronun, TuLoai, Mean, Link) values ('Paper', '/peipo/', 'n', N'Giấy', 'fefefa');

--Phát sinh mã tự động cho bảng BaiHoc
IF OBJECT_ID ('PhatSinhMaTuDong_BaiHoc','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_BaiHoc; 
go
create trigger PhatSinhMaTuDong_BaiHoc
on BaiHoc
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_BaiHoc char(10)
	set @ID_BaiHoc = (select top 1 ID_BaiHoc from BaiHoc order by ID_BaiHoc desc)
	if @ID_BaiHoc is null
	BEGIN		
		Set @ID_BaiHoc = 'BH00000001'

	END
	else
		BEGIN
			set @ID_BaiHoc = Convert(int, SUBSTRING(@ID_BaiHoc, 3, 8)) + 1
			if len(@ID_BaiHoc) = 1
			BEGIN
				set @ID_BaiHoc = 'BH0000000' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 2
			BEGIN
				set @ID_BaiHoc = 'BH000000' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 3
			BEGIN
				set @ID_BaiHoc = 'BH00000' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 4
			BEGIN
				set @ID_BaiHoc = 'BH0000' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 5
			BEGIN
				set @ID_BaiHoc = 'BH000' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 6
			BEGIN
				set @ID_BaiHoc = 'BH00' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 7
			BEGIN
				set @ID_BaiHoc = 'BH0' + @ID_BaiHoc
			END
			else if len(@ID_BaiHoc) = 8
			BEGIN
				set @ID_BaiHoc = 'BH' + @ID_BaiHoc
			END	
		END
		insert into BaiHoc(ID_BaiHoc, NoiDungBaiHoc) values(@ID_BaiHoc, (Select NoiDungBaiHoc from inserted))
																				
		print 'Insert Suscessfull ID_BaiHoc: ' + @ID_BaiHoc
END
GO

--Phát sinh mã tự động cho bảng DeXuatChinhSua
IF OBJECT_ID ('PhatSinhMaTuDong_DeXuatChinhSua','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_DeXuatChinhSua; 
go
create trigger PhatSinhMaTuDong_DeXuatChinhSua
on DeXuatChinhSua
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_DXCS char(10)
	set @ID_DXCS = (select top 1 ID_DXCS from DeXuatChinhSua order by ID_DXCS desc)
	if @ID_DXCS is null
	BEGIN		
		Set @ID_DXCS = 'DXCS000001'

	END
	else
		BEGIN
			set @ID_DXCS = Convert(int, SUBSTRING(@ID_DXCS, 5, 6)) + 1
			if len(@ID_DXCS) = 1
			BEGIN
				set @ID_DXCS = 'DXCS00000' + @ID_DXCS
			END
			else if len(@ID_DXCS) = 2
			BEGIN
				set @ID_DXCS = 'DXCS0000' + @ID_DXCS
			END
			else if len(@ID_DXCS) = 3
			BEGIN
				set @ID_DXCS = 'DXCS000' + @ID_DXCS
			END
			else if len(@ID_DXCS) = 4
			BEGIN
				set @ID_DXCS = 'DXCS00' + @ID_DXCS
			END
			else if len(@ID_DXCS) = 5
			BEGIN
				set @ID_DXCS = 'DXCS0' + @ID_DXCS
			END
			else if len(@ID_DXCS) = 6
			BEGIN
				set @ID_DXCS = 'DXCS' + @ID_DXCS
			END
		END
		insert into DeXuatChinhSua(ID_DXCS, ThoiGian, NoiDungDeXuat, Users) values(@ID_DXCS, (Select ThoiGian from inserted),
																								(Select NoiDungDeXuat from inserted),
																								(Select Users from inserted))
																				
		print 'Insert Suscessfull ID_DXCS: ' + @ID_DXCS
END
GO

insert into DeXuatChinhSua(ThoiGian, NoiDungDeXuat, Users) values ('2016-5-4', 'Đây là nội dung đề xuất số 1', 'u1');

--Phát sinh mã tự động cho bảng Grammar
IF OBJECT_ID ('PhatSinhMaTuDong_Grammar','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_Grammar; 
go
create trigger PhatSinhMaTuDong_Grammar
on Grammar
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_Gr char(10)
	set @ID_Gr = (select top 1 ID_Gr from Grammar order by ID_Gr desc)
	if @ID_Gr is null
	BEGIN		
		Set @ID_Gr = 'Gr00000001'

	END
	else
		BEGIN
			set @ID_Gr = Convert(int, SUBSTRING(@ID_Gr, 3, 8)) + 1
			if len(@ID_Gr) = 1
			BEGIN
				set @ID_Gr = 'Gr0000000' + @ID_Gr
			END
			else if len(@ID_Gr) = 2
			BEGIN
				set @ID_Gr = 'Gr000000' + @ID_Gr
			END
			else if len(@ID_Gr) = 3
			BEGIN
				set @ID_Gr = 'Gr00000' + @ID_Gr
			END
			else if len(@ID_Gr) = 4
			BEGIN
				set @ID_Gr = 'Gr0000' + @ID_Gr
			END
			else if len(@ID_Gr) = 5
			BEGIN
				set @ID_Gr = 'Gr000' + @ID_Gr
			END
			else if len(@ID_Gr) = 6
			BEGIN
				set @ID_Gr = 'Gr00' + @ID_Gr
			END
			else if len(@ID_Gr) = 7
			BEGIN
				set @ID_Gr = 'Gr0' + @ID_Gr
			END
			else if len(@ID_Gr) = 8
			BEGIN
				set @ID_Gr = 'Gr' + @ID_Gr
			END
		END
		insert into Grammar(ID_Gr, Name_Gr, Grammar) values(@ID_Gr, (Select Name_Gr from inserted),
																	(Select Grammar from inserted))
																				
		print 'Insert Suscessfull ID_Gr: ' + @ID_Gr
END
GO

insert into Grammar(Name_Gr, Grammar) values ('Grammar 1', 'Đây là nội dung Grammar số 1');

--Phát sinh mã tự động cho bảng Login
IF OBJECT_ID ('PhatSinhMaTuDong_Login','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_Login; 
go
create trigger PhatSinhMaTuDong_Login
on Login
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_Login char(10)
	set @ID_Login = (select top 1 ID_Login from Login order by ID_Login desc)
	if @ID_Login is null
	BEGIN		
		Set @ID_Login = 'LOG0000001'

	END
	else
		BEGIN
			set @ID_Login = Convert(int, SUBSTRING(@ID_Login, 4, 7)) + 1
			if len(@ID_Login) = 1
			BEGIN
				set @ID_Login = 'LOG000000' + @ID_Login
			END
			else if len(@ID_Login) = 2
			BEGIN
				set @ID_Login = 'LOG00000' + @ID_Login
			END
			else if len(@ID_Login) = 3
			BEGIN
				set @ID_Login = 'LOG0000' + @ID_Login
			END
			else if len(@ID_Login) = 4
			BEGIN
				set @ID_Login = 'LOG000' + @ID_Login
			END
			else if len(@ID_Login) = 5
			BEGIN
				set @ID_Login = 'LOG00' + @ID_Login
			END
			else if len(@ID_Login) = 6
			BEGIN
				set @ID_Login = 'LOG0' + @ID_Login
			END
			else if len(@ID_Login) = 7
			BEGIN
				set @ID_Login = 'LOG' + @ID_Login
			END
		END
		insert into Login(ID_Login, Users, TGLogin) values(@ID_Login, (Select Users from inserted),
																	(Select TGLogin from inserted))
																				
		print 'Insert Suscessfull ID_Login: ' + @ID_Login
END
GO

insert into Login(Users, TGLogin) values ('u1', '2016-8-9');

--Phát sinh mã tự động cho bảng PhanHoi
IF OBJECT_ID ('PhatSinhMaTuDong_PhanHoi','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_PhanHoi; 
go
create trigger PhatSinhMaTuDong_PhanHoi
on PhanHoi
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_PhanHoi char(10)
	set @ID_PhanHoi = (select top 1 ID_PhanHoi from PhanHoi order by ID_PhanHoi desc)
	if @ID_PhanHoi is null
	BEGIN		
		Set @ID_PhanHoi = 'PHOI000001'

	END
	else
		BEGIN
			set @ID_PhanHoi = Convert(int, SUBSTRING(@ID_PhanHoi, 5, 6)) + 1
			if len(@ID_PhanHoi) = 1
			BEGIN
				set @ID_PhanHoi = 'PHOI00000' + @ID_PhanHoi
			END
			else if len(@ID_PhanHoi) = 2
			BEGIN
				set @ID_PhanHoi = 'PHOI0000' + @ID_PhanHoi
			END
			else if len(@ID_PhanHoi) = 3
			BEGIN
				set @ID_PhanHoi = 'PHOI000' + @ID_PhanHoi
			END
			else if len(@ID_PhanHoi) = 4
			BEGIN
				set @ID_PhanHoi = 'PHOI00' + @ID_PhanHoi
			END
			else if len(@ID_PhanHoi) = 5
			BEGIN
				set @ID_PhanHoi = 'PHOI0' + @ID_PhanHoi
			END
			else if len(@ID_PhanHoi) = 6
			BEGIN
				set @ID_PhanHoi = 'PHOI' + @ID_PhanHoi
			END
		END
		insert into PhanHoi(ID_PhanHoi, NoiDung, DaDoc) values(@ID_PhanHoi, (Select NoiDung from inserted),
																			(Select DaDoc from inserted))
																				
		print 'Insert Suscessfull ID_PhanHoi: ' + @ID_PhanHoi
END
GO

--Phát sinh mã tự động cho bảng PhatAm
IF OBJECT_ID ('PhatSinhMaTuDong_PhatAm','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_PhatAm; 
go
create trigger PhatSinhMaTuDong_PhatAm
on PhatAm
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_PhatAm char(10)
	set @ID_PhatAm = (select top 1 ID_PhatAm from PhatAm order by ID_PhatAm desc)
	if @ID_PhatAm is null
	BEGIN		
		Set @ID_PhatAm = 'PAM0000001'
	END
	else
		BEGIN
			set @ID_PhatAm = Convert(int, SUBSTRING(@ID_PhatAm, 4, 7)) + 1
			if len(@ID_PhatAm) = 1
			BEGIN
				set @ID_PhatAm = 'PAM000000' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 2
			BEGIN
				set @ID_PhatAm = 'PAM00000' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 3
			BEGIN
				set @ID_PhatAm = 'PAM0000' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 4
			BEGIN
				set @ID_PhatAm = 'PAM000' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 5
			BEGIN
				set @ID_PhatAm = 'PAM00' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 6
			BEGIN
				set @ID_PhatAm = 'PAM0' + @ID_PhatAm
			END
			else if len(@ID_PhatAm) = 7
			BEGIN
				set @ID_PhatAm = 'PAM' + @ID_PhatAm
			END
		END
		insert into PhatAm(ID_PhatAm, ID_W, Link_PhatAm) values(@ID_PhatAm, (Select ID_W from inserted),
																			(Select Link_PhatAm from inserted))
																				
		print 'Insert Suscessfull ID_PhatAm: ' + @ID_PhatAm
END
GO

insert into PhatAm(ID_W, Link_PhatAm) values ('W000000001', 'fewfa');

--Phát sinh mã tự động cho bảng TaiLieu
IF OBJECT_ID ('PhatSinhMaTuDong_TaiLieu','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_TaiLieu; 
go
create trigger PhatSinhMaTuDong_TaiLieu
on TaiLieu
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_TaiLieu char(10)
	set @ID_TaiLieu = (select top 1 ID_TaiLieu from TaiLieu order by ID_TaiLieu desc)
	if @ID_TaiLieu is null
	BEGIN		
		Set @ID_TaiLieu = 'TLI0000001'
	END
	else
		BEGIN
			set @ID_TaiLieu = Convert(int, SUBSTRING(@ID_TaiLieu, 4, 7)) + 1
			if len(@ID_TaiLieu) = 1
			BEGIN
				set @ID_TaiLieu = 'TLI000000' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 2
			BEGIN
				set @ID_TaiLieu = 'TLI00000' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 3
			BEGIN
				set @ID_TaiLieu = 'TLI0000' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 4
			BEGIN
				set @ID_TaiLieu = 'TLI000' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 5
			BEGIN
				set @ID_TaiLieu = 'TLI00' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 6
			BEGIN
				set @ID_TaiLieu = 'TLI0' + @ID_TaiLieu
			END
			else if len(@ID_TaiLieu) = 7
			BEGIN
				set @ID_TaiLieu = 'TLI' + @ID_TaiLieu
			END
		END
		insert into TaiLieu(ID_TaiLieu, TenTaiLieu, DinhDang) values(@ID_TaiLieu, (Select TenTaiLieu from inserted),
																					(Select DinhDang from inserted))
																				
		print 'Insert Suscessfull ID_TaiLieu: ' + @ID_TaiLieu
END
GO

insert into TaiLieu(TenTaiLieu, DinhDang) values('Tài liệu số 1', 'doc');

--Phát sinh mã tự động cho bảng ThangTrinhDo
IF OBJECT_ID ('PhatSinhMaTuDong_ThangTrinhDo','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_ThangTrinhDo; 
go
create trigger PhatSinhMaTuDong_ThangTrinhDo
on ThangTrinhDo
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_ThangTrinhDo char(10)
	set @ID_ThangTrinhDo = (select top 1 ID_ThangTrinhDo from ThangTrinhDo order by ID_ThangTrinhDo desc)
	if @ID_ThangTrinhDo is null
	BEGIN		
		Set @ID_ThangTrinhDo = 'TTD0000001'
	END
	else
		BEGIN
			set @ID_ThangTrinhDo = Convert(int, SUBSTRING(@ID_ThangTrinhDo, 4, 7)) + 1
			if len(@ID_ThangTrinhDo) = 1
			BEGIN
				set @ID_ThangTrinhDo = 'TTD000000' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 2
			BEGIN
				set @ID_ThangTrinhDo = 'TTD00000' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 3
			BEGIN
				set @ID_ThangTrinhDo = 'TTD0000' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 4
			BEGIN
				set @ID_ThangTrinhDo = 'TTD000' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 5
			BEGIN
				set @ID_ThangTrinhDo = 'TTD00' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 6
			BEGIN
				set @ID_ThangTrinhDo = 'TTD0' + @ID_ThangTrinhDo
			END
			else if len(@ID_ThangTrinhDo) = 7
			BEGIN
				set @ID_ThangTrinhDo = 'TTD' + @ID_ThangTrinhDo
			END
		END
		insert into ThangTrinhDo(ID_ThangTrinhDo, ThoiGian, TrinhDo, Users) values(@ID_ThangTrinhDo, (Select ThoiGian from inserted),
																										(Select TrinhDo from inserted),
																										(Select Users from inserted))
																				
		print 'Insert Suscessfull ID_ThangTrinhDo: ' + @ID_ThangTrinhDo
END
GO

insert into ThangTrinhDo(ThoiGian, TrinhDo, Users) values('2016-3-9', 'Trình độ 1', 'U000000002');

--Phát sinh mã tự động cho bảng TraCuuThongTin
IF OBJECT_ID ('PhatSinhMaTuDong_TraCuuThongTin','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_TraCuuThongTin; 
go
create trigger PhatSinhMaTuDong_TraCuuThongTin
on TraCuuThongTin
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_TraCuuThongTin char(10)
	set @ID_TraCuuThongTin = (select top 1 ID_TraCuuThongTin from TraCuuThongTin order by ID_TraCuuThongTin desc)
	if @ID_TraCuuThongTin is null
	BEGIN		
		Set @ID_TraCuuThongTin = 'TCTT000001'
	END
	else
		BEGIN
			set @ID_TraCuuThongTin = Convert(int, SUBSTRING(@ID_TraCuuThongTin, 5, 6)) + 1
			if len(@ID_TraCuuThongTin) = 1
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT00000' + @ID_TraCuuThongTin
			END
			else if len(@ID_TraCuuThongTin) = 2
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT0000' + @ID_TraCuuThongTin
			END
			else if len(@ID_TraCuuThongTin) = 3
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT000' + @ID_TraCuuThongTin
			END
			else if len(@ID_TraCuuThongTin) = 4
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT00' + @ID_TraCuuThongTin
			END
			else if len(@ID_TraCuuThongTin) = 5
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT0' + @ID_TraCuuThongTin
			END
			else if len(@ID_TraCuuThongTin) = 6
			BEGIN
				set @ID_TraCuuThongTin = 'TCTT' + @ID_TraCuuThongTin
			END
		END
		insert into TraCuuThongTin(ID_TraCuuThongTin, NoiDung) values(@ID_TraCuuThongTin, (Select NoiDung from inserted))
																				
		print 'Insert Suscessfull ID_TraCuuThongTin: ' + @ID_TraCuuThongTin
END
GO

insert into TraCuuThongTin(NoiDung) values(N'Đây là nội dung tra cứu thông tin số 1');

--Phát sinh mã tự động cho bảng TroGiup
IF OBJECT_ID ('PhatSinhMaTuDong_TroGiup','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_TroGiup; 
go
create trigger PhatSinhMaTuDong_TroGiup
on TroGiup
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_TroGiup char(10)
	set @ID_TroGiup = (select top 1 ID_TroGiup from TroGiup order by ID_TroGiup desc)
	if @ID_TroGiup is null
	BEGIN		
		Set @ID_TroGiup = 'TGIU000001'
	END
	else
		BEGIN
			set @ID_TroGiup = Convert(int, SUBSTRING(@ID_TroGiup, 5, 6)) + 1
			if len(@ID_TroGiup) = 1
			BEGIN
				set @ID_TroGiup = 'TGIU00000' + @ID_TroGiup
			END
			else if len(@ID_TroGiup) = 2
			BEGIN
				set @ID_TroGiup = 'TGIU0000' + @ID_TroGiup
			END
			else if len(@ID_TroGiup) = 3
			BEGIN
				set @ID_TroGiup = 'TGIU000' + @ID_TroGiup
			END
			else if len(@ID_TroGiup) = 4
			BEGIN
				set @ID_TroGiup = 'TGIU00' + @ID_TroGiup
			END
			else if len(@ID_TroGiup) = 5
			BEGIN
				set @ID_TroGiup = 'TGIU0' + @ID_TroGiup
			END
			else if len(@ID_TroGiup) = 6
			BEGIN
				set @ID_TroGiup = 'TGIU' + @ID_TroGiup
			END
		END
		insert into TroGiup(ID_TroGiup, NoiDungTroGiup) values(@ID_TroGiup, (Select NoiDungTroGiup from inserted))
																				
		print 'Insert Suscessfull ID_NoiDungTroGiup: ' + @ID_TroGiup
END
GO

insert into TroGiup(NoiDungTroGiup) values(N'Đây là nội dung trợ giúp số 1');

--Phát sinh mã tự động cho bảng User_PhatAm
IF OBJECT_ID ('PhatSinhMaTuDong_User_PhatAm','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_User_PhatAm; 
go
create trigger PhatSinhMaTuDong_User_PhatAm
on User_PhatAm
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_User_PhatAm char(10)
	set @ID_User_PhatAm = (select top 1 ID_UserPhatAm from User_PhatAm order by ID_UserPhatAm desc)
	if @ID_User_PhatAm is null
	BEGIN		
		Set @ID_User_PhatAm = 'UPAM000001'
	END
	else
		BEGIN
			set @ID_User_PhatAm = Convert(int, SUBSTRING(@ID_User_PhatAm, 5, 6)) + 1
			if len(@ID_User_PhatAm) = 1
			BEGIN
				set @ID_User_PhatAm = 'UPAM00000' + @ID_User_PhatAm
			END
			else if len(@ID_User_PhatAm) = 2
			BEGIN
				set @ID_User_PhatAm = 'UPAM0000' + @ID_User_PhatAm
			END
			else if len(@ID_User_PhatAm) = 3
			BEGIN
				set @ID_User_PhatAm = 'UPAM000' + @ID_User_PhatAm
			END
			else if len(@ID_User_PhatAm) = 4
			BEGIN
				set @ID_User_PhatAm = 'UPAM00' + @ID_User_PhatAm
			END
			else if len(@ID_User_PhatAm) = 5
			BEGIN
				set @ID_User_PhatAm = 'UPAM0' + @ID_User_PhatAm
			END
			else if len(@ID_User_PhatAm) = 6
			BEGIN
				set @ID_User_PhatAm = 'UPAM' + @ID_User_PhatAm
			END
		END
		insert into User_PhatAm(ID_UserPhatAm, ThoiGianPhatAm, Users, ID_W, Link_UserPhatAm) values(@ID_User_PhatAm, (Select ThoiGianPhatAm from inserted),
																											(Select Users from inserted),
																											(Select ID_W from inserted),
																											(Select Link_UserPhatAm from inserted))
																				
		print 'Insert Suscessfull ID_UserPhatAm: ' + @ID_User_PhatAm
END
GO

insert into User_PhatAm(ThoiGianPhatAm, Users, ID_W, Link_UserPhatAm) values ('2016-8-9', 'U000000002', 'W000000001', 'gouis');

--Phát sinh mã tự động cho bảng User_Vocabulary
IF OBJECT_ID ('PhatSinhMaTuDong_User_Vocabulary','TR') IS NOT NULL DROP TRIGGER PhatSinhMaTuDong_User_Vocabulary; 
go
create trigger PhatSinhMaTuDong_User_Vocabulary
on User_Vocabulary
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ID_ID_Voca char(10)
	set @ID_ID_Voca = (select top 1 ID_Voca from User_Vocabulary order by ID_Voca desc)
	if @ID_ID_Voca is null
	BEGIN		
		Set @ID_ID_Voca = 'UVOC000001'
	END
	else
		BEGIN
			set @ID_ID_Voca = Convert(int, SUBSTRING(@ID_ID_Voca, 5, 6)) + 1
			if len(@ID_ID_Voca) = 1
			BEGIN
				set @ID_ID_Voca = 'UVOC00000' + @ID_ID_Voca
			END
			else if len(@ID_ID_Voca) = 2
			BEGIN
				set @ID_ID_Voca = 'UVOC0000' + @ID_ID_Voca
			END
			else if len(@ID_ID_Voca) = 3
			BEGIN
				set @ID_ID_Voca = 'UVOC000' + @ID_ID_Voca
			END
			else if len(@ID_ID_Voca) = 4
			BEGIN
				set @ID_ID_Voca = 'UVOC00' + @ID_ID_Voca
			END
			else if len(@ID_ID_Voca) = 5
			BEGIN
				set @ID_ID_Voca = 'UVOC0' + @ID_ID_Voca
			END
			else if len(@ID_ID_Voca) = 6
			BEGIN
				set @ID_ID_Voca = 'UVOC' + @ID_ID_Voca
			END
		END
		insert into User_Vocabulary(ID_Voca, Voca, Mean_Voca, Date_Voca, Users, ID_W) values(@ID_ID_Voca, (Select Voca from inserted),
																											(Select Mean_Voca from inserted),
																											(Select Date_Voca from inserted),
																											(Select Users from inserted),
																											(Select ID_W from inserted))
																				
		print 'Insert Suscessfull ID_Voca: ' + @ID_ID_Voca
END
GO

insert into User_Vocabulary(Voca, Mean_Voca, Date_Voca, Users, ID_W) values ('Paper', 'Giấy', '2016-8-1', 'u000000002', 'W000000001');
--============================================= VIEW ========================================================
--Bảng kiểm tra từ thành viên đã thêm từ học vào chưa
if OBJECT_ID('KiemTraHocTu_User', 'V') is not null
	drop view KiemTraHocTu_User
go
create view KiemTraHocTu_User as
	select User_Vocabulary.ID_W as ID_W_VoCa,Dictionary.Word as Word_VoCa
	from Dictionary,User_Vocabulary
	where Dictionary.ID_W=User_Vocabulary.ID_W;
go


--Bảng kiểm tra từ thành viên đã thêm từ phát âm vào chưa
if OBJECT_ID('BangThemTuPhatAm', 'V') is not null
	drop view BangThemTuPhatAm
go
create view BangThemTuPhatAm as
	select User_PhatAm.ID_W,Dictionary.Word
	from Dictionary,User_PhatAm
	where Dictionary.ID_W=User_PhatAm.ID_W;
go

--=========================================== PROCEDURE =====================================================
--Thêm 1 từ vào usersPhatAm
if OBJECT_ID('ThemUSersPhatAm', 'pr') is not null
	drop procedure ThemUSersPhatAm
go
create PROCEDURE ThemUSersPhatAm(@Word varchar(20),@User varchar(50), @ThoiGian datetime) 
as 
begin
	declare @Link varchar(50),@IDW char(10)
	select @Link=PhatAm.Link_PhatAm, @IDW=Dictionary.ID_W
	from Dictionary,TaiKhoan,PhatAm,User_PhatAm
	where  @Word=Dictionary.Word and @User=TaiKhoan.Users 
			and PhatAm.ID_W=Dictionary.ID_W and Dictionary.ID_W=User_PhatAm.ID_W and User_PhatAm.Users=TaiKhoan.Users
		
	insert into User_PhatAm(ThoiGianPhatAm,Users,ID_W,Link_UserPhatAm) values(@ThoiGian,@User,@IDW,@Link)
end
go


--Thêm 1 từ vào usersVocabulary, tạo bảng kiểm tra từ trùng chưa nhưng gọi không được
if OBJECT_ID('ThemUsersVocabulary', 'P') is not null
	drop PROCEDURE ThemUsersVocabulary
go
create PROCEDURE ThemUsersVocabulary(@Word varchar(20),@User varchar(50), @ThoiGian datetime) 
as 
begin
	declare @Mean nvarchar(50),@IDW char(10)
	select  @Mean=Dictionary.Mean,@IDW=Dictionary.ID_W
	from Dictionary,User_Vocabulary,TaiKhoan
	where  Dictionary.ID_W=User_Vocabulary.ID_W 
	and @Word=Dictionary.Word and @User=TaiKhoan.Users and TaiKhoan.Users=User_Vocabulary.Users 
	
	insert into User_Vocabulary(Voca,Mean_Voca,Date_Voca,Users,ID_W) values(@Word,@Mean,@ThoiGian,@User,@IDW)
end;


--Thêm 1 user vào thang trình độ
if OBJECT_ID('ThemTrinhDoUser', 'P') is not null
	drop procedure ThemTrinhDoUser
go
create PROCEDURE ThemTrinhDoUser(@User varchar(50),@TrinhDo nvarchar(30),@ThoiGian datetime)
as
begin
	declare @userthang varchar(50),@usertaikhoan varchar(50)
	select @userthang=ThangTrinhDo.Users,@usertaikhoan=TaiKhoan.Users
	from ThangTrinhDo,TaiKhoan
	if @userthang<>@User and @usertaikhoan=@User
		begin
			insert into ThangTrinhDo(ThoiGian,TrinhDo,Users) values (@ThoiGian,@TrinhDo,@User)
		end
end;

--Cập nhật thang trình độ cho Thành viên
if OBJECT_ID('UpdateTrinhDoUser', 'p') is not null
	drop procedure UpdateTrinhDoUser
go
create PROCEDURE UpdateTrinhDoUser(@User varchar(50),@TrinhDo nvarchar(30),@ThoiGian datetime)
as
begin
	declare @userthang varchar(50)
	select @userthang=ThangTrinhDo.Users
	from ThangTrinhDo
	if @userthang=@User
		begin
			update ThangTrinhDo set ThoiGian=@ThoiGian,TrinhDo=@TrinhDo,Users=@User
		end
end;


--Thêm tài khoản
if OBJECT_ID('ThemUser', 'P') is not null
	drop procedure ThemUser
go
create PROCEDURE ThemUser(@User varchar(50),@Pass varchar(50),@NgaySinh date,@SDT varchar(15),@Email varchar(50), @ChucVu bit)
as
begin
	declare @usertaikhoan varchar(50)
	select @usertaikhoan=TaiKhoan.Users
	from TaiKhoan
	if  @usertaikhoan<>@User
		begin
			insert into TaiKhoan values (@User,@Pass,@NgaySinh,@SDT,@Email, @ChucVu)
		end
end;

--Cập nhật tài khoản
if OBJECT_ID ('UpdateUser', 'P') is not null
	drop procedure UpdateUser
go
create PROCEDURE UpdateUser(@User varchar(50),@Pass varchar(50),@NgaySinh date,@SDT varchar(15),@Email varchar(50))
as
begin
	declare @usertaikhoan varchar(50)
	select @usertaikhoan=TaiKhoan.Users
	from TaiKhoan
	if @usertaikhoan=@User
		begin
			update TaiKhoan set Users=@User,Passwd=@Pass,NgaySinh=@NgaySinh,SDT=@SDT,Email=@Email
		end
end;


--Thêm từ vựng
if OBJECT_ID ('ThemDictionary', 'P') is not null
	drop procedure ThemDictionary
go
create PROCEDURE ThemDictionary(@Word varchar(20),@Pronun char(20),@Mean nvarchar(50),@Link varchar(50))
as
begin
	insert into Dictionary(Word,Pronun,Mean,Link) values (@Word,@Pronun,@Mean,@Link)
end;


--Cập nhật từ vựng
if OBJECT_ID ('UpdateDictionary', 'P') is not null
	drop procedure UpdateDictionary
go
create PROCEDURE UpdateDictionary(@Word varchar(20),@Pronun char(20),@Mean nvarchar(50),@Link varchar(50))
as
begin
	declare @Worddic varchar(50)
	select @Worddic=Dictionary.Word from Dictionary
	if  @Worddic=@Word
		begin
			update Dictionary set Word=@Word,Pronun=@Pronun,Mean=@Mean,Link=@Link
		end
end;


--Thêm ngữ pháp
if OBJECT_ID ('ThemGrammar', 'P') is not null
	drop procedure ThemGrammar
go
create PROCEDURE ThemGrammar(@Name varchar(30), @Grammar nvarchar(500))
as
begin
	declare @Namegr varchar(50)
	select @Namegr=Grammar.Name_Gr
	from Grammar
	if  @Namegr<>@Name
		begin
			insert into Grammar(Name_Gr,Grammar) values (@Name,@Grammar)
		end
end;


--Cập nhật ngữ pháp
if OBJECT_ID ('UpdateGrammar', 'P') is not null
	drop procedure UpdateGrammar
go
create PROCEDURE UpdateGrammar(@Name varchar(30), @Grammar nvarchar(500))
as
begin
	declare @Namegr varchar(50)
	select @Namegr=Grammar.Name_Gr
	from Grammar
	if  @Namegr=@Name
		begin
			update Grammar set Name_Gr=@Name,Grammar=@Grammar
		end
end;

--============================================ FUNCTION =====================================================
--Hàm trả về bảng các phản hồi chưa đọc
if OBJECT_ID('fPhanHoiChuaDoc', 'if') is not null
	drop function fPhanHoiChuaDoc
go


--=========================================== FUNCTION =====================================================
if OBJECT_ID('fPhanHoiChuaDoc', 'if') is not null
	drop function fPhanHoiChuaDoc
go
create function fPhanHoiChuaDoc()
returns table
as
	return (select NoiDung as Phản_hồi_chưa_đọc from PhanHoi where DaDoc=0)
go

Select * from fPhanHoiChuaDoc()

--Hàm trả về bảng các phản hồi đã đọc
if OBJECT_ID('fPhanHoiDaDoc', 'if') is not null
	drop function fPhanHoiDaDoc
go
create function fPhanHoiDaDoc()
returns table
as
	return (select NoiDung as Phản_hồi_đã_đọc from PhanHoi where DaDoc=1)
go

Select * from fPhanHoiDaDoc()

--Hàm trả về bảng tất cả phản hồi
if OBJECT_ID('fTatCaPhanHoi', 'if') is not null
	drop function fTatCaPhanHoi
go
create function fTatCaPhanHoi()
returns table
as
	return (select ID_PhanHoi, NoiDung, DaDoc as Trạng_thái from PhanHoi)
go

Select * from fTatCaPhanHoi()


--Quốc Đại
--Thành viên học phát âm lại từ đã lưu lúc trước
if OBJECT_ID('LuyenPhatAm', 'if') is not null
	drop function LuyenPhatAm
go
create function LuyenPhatAm(@Word varchar(20),@User varchar(50))
returns table
as 
return
	select Dictionary.ID_W, Dictionary.Pronun, Dictionary.Mean, User_PhatAm.Users, User_PhatAm.Link_UserPhatAm
	from Dictionary,User_PhatAm
	where @Word=Dictionary.Word and Dictionary.ID_W=User_PhatAm.ID_W and @User=User_PhatAm.Users
go


--Thành viên học lại từ đã lưu lúc trước
if OBJECT_ID('LuyenTu', 'if') is not null
	drop function LuyenTu
go
create function LuyenTu(@Word varchar(20),@User varchar(50)) 
returns table
as 
return
	select Dictionary.ID_W, Dictionary.Pronun, User_Vocabulary.Mean_Voca, User_Vocabulary.Users, User_Vocabulary.Voca,User_Vocabulary.ID_Voca
	from Dictionary,User_Vocabulary
	where @Word=Dictionary.Word and Dictionary.ID_W=User_Vocabulary.ID_W and @User=User_Vocabulary.Users
go


--Xem các từ thành viên thêm vào để học phát âm
if OBJECT_ID('XemUserPhatAm','if') is not null
	drop function XemUserPhatAm
go
create function XemUserPhatAm (@User varchar(50))
returns table
as 
return 
	select Dictionary.Word,Dictionary.Pronun,Dictionary.Mean,User_PhatAm.Link_UserPhatAm,User_PhatAm.ThoiGianPhatAm
	from User_PhatAm,Dictionary
	where @User=User_PhatAm.Users and Dictionary.ID_W=User_PhatAm.ID_W


--Xem các từ thành viên thêm vào để học từ vựng
if OBJECT_ID('XemUserVocabulary','if') is not null
	drop function XemUserVocabulary
go
create function XemUserVocabulary (@User varchar(50))
returns table
as 
return 
	select User_Vocabulary.Voca,User_Vocabulary.Mean_Voca,Dictionary.Pronun,Dictionary.Link,User_Vocabulary.Date_Voca
	from User_Vocabulary,Dictionary
	where @User=User_Vocabulary.Users and Dictionary.ID_W=User_Vocabulary.ID_W


--Xem thang trình độ
if OBJECT_ID('XemThangTrinhDo','if') is not null
	drop function XemThangTrinhDo
go
create function XemThangTrinhDo(@User varchar(50))
returns table
as 
return 
	select ThangTrinhDo.Users,ThangTrinhDo.TrinhDo,ThangTrinhDo.ThoiGian
	from ThangTrinhDo
	where @User=ThangTrinhDo.Users 

