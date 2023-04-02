USE [master]
GO
/****** Object:  Database [CCS]    Script Date: 09/12/2022 10:18:39 CH ******/
CREATE DATABASE [CCS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CCS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CCS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CCS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CCS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CCS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CCS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CCS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CCS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CCS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CCS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CCS] SET ARITHABORT OFF 
GO
ALTER DATABASE [CCS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CCS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CCS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CCS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CCS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CCS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CCS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CCS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CCS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CCS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CCS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CCS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CCS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CCS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CCS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CCS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CCS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CCS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CCS] SET  MULTI_USER 
GO
ALTER DATABASE [CCS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CCS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CCS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CCS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CCS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CCS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CCS] SET QUERY_STORE = OFF
GO
USE [CCS]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[idBill] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Total] [bigint] NULL,
	[Status] [bit] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_Bill] PRIMARY KEY CLUSTERED 
(
	[idBill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillDetails]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillDetails](
	[idBill] [int] NOT NULL,
	[id] [int] NOT NULL,
	[amount] [int] NULL,
 CONSTRAINT [PK_BillDetails] PRIMARY KEY CLUSTERED 
(
	[idBill] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponsDetail]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponsDetail](
	[couponid] [int] NOT NULL,
	[couponcode] [varchar](50) NOT NULL,
	[discount] [int] NOT NULL,
	[maxdiscount] [int] NOT NULL,
	[tilldate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[image] [nvarchar](max) NOT NULL,
	[descriptions] [nvarchar](max) NOT NULL,
	[categoryId] [int] NOT NULL,
	[price] [bigint] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCart](
	[Email] [nvarchar](100) NOT NULL,
	[id] [int] NOT NULL,
	[Amount] [int] NULL,
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[Email] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 09/12/2022 10:18:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Email] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Address] [nvarchar](400) NULL,
	[ResetPasswordCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (1, N'congdo2603@gmail.com', 87980000, 1, CAST(N'2022-11-22T13:08:29.473' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (2, N'congdo2603@gmail.com', 44489000, 1, CAST(N'2022-11-25T13:28:49.543' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (3, N'cuongnguyenc.n1612@gmail.com', 689000, 1, CAST(N'2022-11-26T15:24:31.347' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (4, N'cuongnguyenc.n1612@gmail.com', 399000, 1, CAST(N'2022-11-26T15:31:33.527' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (5, N'cuongnguyenc.n1612@gmail.com', 43990000, 1, CAST(N'2022-11-26T15:47:20.980' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (6, N'cuongnguyenc.n1612@gmail.com', 43990000, 1, CAST(N'2022-11-26T15:47:35.593' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (7, N'cuongnguyenc.n1612@gmail.com', 290000, 1, CAST(N'2022-11-27T14:24:24.860' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (8, N'cuongnguyenc.n1612@gmail.com', 49480000, 1, CAST(N'2022-12-08T20:06:07.367' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (9, N'cuongnguyenc.n1612@gmail.com', 49000000, 1, CAST(N'2022-12-08T20:12:04.090' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (10, N'congdo2603@gmail.com', 10519000, 0, CAST(N'2022-12-09T00:00:39.590' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (11, N'congdo2603@gmail.com', 399000, 0, CAST(N'2022-12-09T00:01:19.723' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (12, N'congdo2603@gmail.com', 399000, 1, CAST(N'2022-12-09T00:01:51.520' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (13, N'cuongnguyenc.n1612@gmail.com', 379000, 1, CAST(N'2022-12-09T00:04:56.753' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (14, N'cuongnguyenc.n1612@gmail.com', 290000, 1, CAST(N'2022-12-09T00:08:28.187' AS DateTime))
INSERT [dbo].[Bill] ([idBill], [Email], [Total], [Status], [Date]) VALUES (15, N'congdo2603@gmail.com', 290000, 0, CAST(N'2022-12-09T15:55:38.300' AS DateTime))
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (1, 1, 2)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (2, 1, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (2, 4, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (3, 2, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (3, 5, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (4, 5, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (5, 1, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (6, 1, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (7, 2, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (8, 1, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (8, 14, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (9, 11, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (10, 15, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (10, 16, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (10, 19, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (11, 5, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (12, 5, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (13, 25, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (14, 2, 1)
INSERT [dbo].[BillDetails] ([idBill], [id], [amount]) VALUES (15, 2, 1)
GO
INSERT [dbo].[Categories] ([id], [name]) VALUES (1, N'Sản phẩm Apple')
INSERT [dbo].[Categories] ([id], [name]) VALUES (2, N'Laptop')
INSERT [dbo].[Categories] ([id], [name]) VALUES (3, N'RAM - Bộ nhớ')
INSERT [dbo].[Categories] ([id], [name]) VALUES (4, N'Ổ cứng')
INSERT [dbo].[Categories] ([id], [name]) VALUES (5, N'CPU - Bộ vi xử lý')
INSERT [dbo].[Categories] ([id], [name]) VALUES (6, N'PSU - Nguồn máy tính')
INSERT [dbo].[Categories] ([id], [name]) VALUES (7, N'PC - Màn hình máy tính')
INSERT [dbo].[Categories] ([id], [name]) VALUES (8, N'PC - Phụ kiện')
INSERT [dbo].[Categories] ([id], [name]) VALUES (9, N'Case - Thùng máy tính')
INSERT [dbo].[Categories] ([id], [name]) VALUES (10, N'Tản nhiệt')
INSERT [dbo].[Categories] ([id], [name]) VALUES (11, N'VGA - Card màn hình')
INSERT [dbo].[Categories] ([id], [name]) VALUES (12, N'Mainboard - Bo mạch chủ')
INSERT [dbo].[Categories] ([id], [name]) VALUES (13, N'Thiết bị âm thanh')
INSERT [dbo].[Categories] ([id], [name]) VALUES (14, N'PC - Máy tính bộ')
GO
INSERT [dbo].[CouponsDetail] ([couponid], [couponcode], [discount], [maxdiscount], [tilldate]) VALUES (1, N'FREESHIP', 10, 2000, CAST(N'2023-10-25T00:00:00.000' AS DateTime))
INSERT [dbo].[CouponsDetail] ([couponid], [couponcode], [discount], [maxdiscount], [tilldate]) VALUES (2, N'NGAYMOI', 20, 700, CAST(N'2022-12-30T00:00:00.000' AS DateTime))
INSERT [dbo].[CouponsDetail] ([couponid], [couponcode], [discount], [maxdiscount], [tilldate]) VALUES (3, N'NOELVUIVE', 30, 3500, CAST(N'2022-12-24T00:00:00.000' AS DateTime))
INSERT [dbo].[CouponsDetail] ([couponid], [couponcode], [discount], [maxdiscount], [tilldate]) VALUES (4, N'CUOITUAN', 15, 1200, CAST(N'2023-01-01T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (1, N'APPLE MACBOOK PRO M1 16GB 256GB', N'/app/img/sanpham/macbookpro13.jfif', N'Xử lý đồ hoạ mượt mà - Chip M1 cho phép thao tác trên các phần mềm AI, Photoshop, Render Video, phát trực tiếp ở độ phân giải 4K Chất lượng hiển thị sắc nét - Độ phân giải retina màu sắc rực rỡ, tấm nền IPS cho góc nhìn 178 độ Bảo mật cao - Trang bị cảm biến vân tay cho phép mở máy chỉ với 1 chạm Mỏng nhẹ cao cấp - Mỏng chỉ 15.6mm, trọng lượng chỉ 1.4kg đồng hành cùng bạn mọi lúc mọi nơi Cảm giác gõ thoải mái - Bàn phím magic khắc phục hầu hết các nhược điểm củ thế hệ trước.', 1, 43990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (2, N'Bộ nguồn ASUS', N'/app/img/sanpham/bonguon.png', N'Đang cập nhật', 6, 290000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (3, N'Laptop ASUS 3 8GB 512GB', N'/app/img/sanpham/laptop acer 3.png', N'Đang cập nhật', 2, 14990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (4, N'Bàn phím DERUE PINK ', N'/app/img/sanpham/banphimDerue.jpg', N'đang cập nhật', 8, 499000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (5, N'Chuột ASUS ROG Led', N'/app/img/sanpham/chuotasusrog.jpg', N'đang cập nhật', 8, 399000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (6, N'Pin Laptop Lenovo ThinkPad', N'/app/img/sanpham/Pin-Lenovo-Thinkpad.jpg', N'đang cập nhật', 6, 1399000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (9, N'MacBook Pro 2018 13.3 inch MR9R2', N'/app/img/sanpham/mac2018.png', N'MacBook Pro nâng tầm khái niệm notebook lên một tầm cao mới, với hiệu năng và tính di động chuẩn mực. Cùng phác họa và phát triển ý tưởng của bạn nhanh hơn bao giờ hết, nhờ có sự hỗ trợ của vi xử lý hiệu năng cao cùng với bộ nhớ, dung lượng lưu trữ và đồ họa tân tiến. Với bộ xử lý Intel Core thế hệ thứ tám, MacBook Pro đạt đến tầm cao mới về hiệu năng tính toán. Model 15 inch hiện có bộ xử lý Intel Core i9 6 nhân, hoạt động nhanh hơn tới 70% so với thế hệ trước, cho phép tốc độ Turbo Boost lên tới 4,8 GHz. 

Trong khi đó, bộ xử lý lõi tứ trên Apple MacBook Pro 13.3” MR9R2 với Touch Bar giờ đây giúp nó nhanh gấp đôi so với thế hệ trước. Vì vậy, khi thực hiện các công việc xử lý cấp độ như biên dịch mã, kết xuất mô hình 3D, thêm hiệu ứng đặc biệt, xếp lớp nhiều bản nhạc hoặc mã hóa video, bạn sẽ hoàn thành mọi việc với tốc độ nhanh hơn.', 1, 24945000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (11, N'PC APPLE iMac Z0ZX 27"5K/Intel Core i7/16GB/512GBSSD', N'/app/img/sanpham/imac275k.png', N'Update', 1, 49000000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (12, N'Máy tính để bàn - PC Acer Aspire AS-XC780 DT.B8ASV.006', N'/app/img/sanpham/pc1.png', N'Máy bộ Acer Aspire XC-780 DT.B8ASV.006 được thiết kế nhỏ gọn, giúp bạn tiết kiệm nhiều không gian, bạn có thể dễ dàng đặt nó dưới chân bàn để tiết kiệm diện tích. Bên cạnh đó với thiết kế đẹp với tông màu đen, sản phẩm còn giúp căn phòng làm việc của bạn trở nên hoàn hảo, chuyên nghiệp hơn. Với bộ vi xử lý Intel Core i5 7400 3.00 GHz up to 3.50 GHz, 6MB, dung lượng RAM 4GB cùng card đồ họa NVIDIA GeForce GT 720 2GB, máy thực hiện tốt các ứng dụng văn phòng, hỗ trợ đa nhiệm tốt. Ổ cứng có dung lượng 1TB để bạn có thể lưu trữ được nhiều dữ liệu hơn. 

Máy bộ Acer Aspire XC-780 DT.B8ASV.006 cũng được trang bị đầy đủ các cổng giao tiếp, kết nối để chia sẽ dữ liệu và kết nối với các thiết bị ngoại vi. Ngoài ra sản phẩm cũng được tích hợp wifi để người dùng dễ dàng truy cập internet', 14, 11499000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (13, N'Máy tính để bàn - PC Dell Inspiron 3470 SFF STI51315', N'/app/img/sanpham/pc2.png', N'(i5-8400/8GB/1TB HDD/UHD 630/Ubuntu)', 14, 12490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (14, N'Màn hình LCD MSI Optix G27C7', N'/app/img/sanpham/lcdmsi.png', N'Update', 7, 5490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (15, N'Màn hình LCD Lenovo D22e-20', N'/app/img/sanpham/lcdlenovo.png', N'(1920 x 1080/VA/75Hz/4 ms/FreeSync) Màn hình LCD Lenovo D22e-20 được đánh giá là dòng màn hình thông minh vượt trội nhất hiện nay, Lenovo đã cho ra mắt Màn hình LCD Lenovo D22e-20 với nhiều sự cải tiến cả về diện mạo lẫn chất lượng để đáp ứng  được đầy đủ về nhu cầu sử dụng cao cấp của người tiêu dùng hiện nay, hứa hẹn sẽ mang lại những trải nghiệm thú vị, cho bạn cái nhìn hoàn thiện hơn.', 7, 2490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (16, N'HDD WD Black P10 Game Drive 2TB USB3.2', N'/app/img/sanpham/hddp102tb.png', N'Bộ nhớ di động cho bộ sưu tập trò chơi tuyệt vời của bạn
Ổ đĩa trò chơi WD_BLACK ™ P10 cung cấp cho bảng điều khiển hoặc PC của bạn các công cụ nâng cao hiệu suất cần thiết để giữ lợi thế cạnh tranh của bạn. Đây là ổ cứng gắn ngoài hàng đầu với dung lượng lên tới 5TB, được chế tạo dành riêng cho các game thủ muốn mở rộng tiềm năng của bảng điều khiển hoặc PC bằng cách lưu thư viện trò chơi của họ theo hình thức di chuyển. Giờ đây, với Ổ đĩa trò chơi WD_BLACK ™ P10, bạn có thể lái trò chơi của mình theo cách bạn chọn.

Mở rộng vương quốc của bạn
Khi thư viện trò chơi của bạn phát triển, bạn sẽ cần không gian để lưu các tựa game quý giá mới của mình, cùng với phòng trống để lưu các mục yêu thích cũ của bạn. Ổ đĩa trò chơi WD_BLACK ™ P10 có dung lượng lên tới 5TB có thể lưu tới 125 trò chơi 3 , do đó bạn không phải thỏa hiệp những trò chơi nào cần xóa trên bảng điều khiển hoặc PC để có chỗ cho những trò chơi mới.

Bất cứ nơi nào bạn đi, trò chơi của bạn
Theo dõi nhanh chóng vào trò chơi, bất kể bạn đang ở đâu. Yếu tố hình thức dễ dàng di động và độ bền cao của WD_BLACK ™ P10 mang đến cho bạn khả năng mang thư viện bên mình mọi lúc mọi nơi. Chỉ cần cắm, đăng nhập và bạn đã sẵn sàng chơi bất kỳ trò chơi nào trong bộ sưu tập 4 bạn mong muốn .

Được xây dựng để tốt hơn
Mọi thứ đi vào các thiết bị WD_BLACK ™ được thiết kế đặc biệt để đưa trò chơi của bạn đi xa hơn, bất kể bạn chơi gì. Với tốc độ lên tới 140MB / s 2 và tối đa 5TB 1 dung lượng lưu trữ bổ sung, Ổ đĩa trò chơi WD_BLACK ™ P10 sẽ đẩy bảng điều khiển hoặc PC của bạn lên mức hiệu suất mới, cho phép bạn lái trò chơi và chơi mà không bị giới hạn.

Thắng mà không phải lo lắng
WD_BLACK ™ đang phá vỡ khuôn mẫu khi nói đến hiệu suất và mở rộng lưu trữ cao cấp. Được xây dựng có mục đích cho các game thủ, WD_BLACK ™ P10 Game Drive mang đến cho bảng điều khiển hoặc PC của bạn khả năng tăng cường hiệu suất đáng tin cậy, đáng tin cậy và cần có, vì vậy bạn sẽ mất ít thời gian hơn để lo lắng về phần cứng của mình và giành được nhiều thời gian hơn', 4, 3039000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (17, N'CPU INTEL Core i7-12700 (12C/20T, 4.90 GHz, 25MB) - 1700', N'/app/img/sanpham/corei712700.png', N'CPU Intel Core i7 12700 là một trong những CPU dòng Alder Lake cao cấp có sức mạnh phân bổ hiệu quả, mang đến hiệu năng vượt trội để bạn có trải nghiệm mượt mà hơn bao giờ hết. Core i7 12700 cao cấp hứa hẹn sẽ là trợ thủ đắc lực giúp bạn nâng cấp cấu hình dàn PC hiện tại của mình. 
Tính tương thích cao, cấu trúc 12 nhân 20 luồng mạnh mẽ
CPU Intel Core i7 12700 có thể chạy được trên nhiều bo mạch chủ như H610, B660, H670 hay Z690 và tương thích với socket LGA 1700 thế hệ mới. CPU thế hệ thứ 12 trên nền socket LGA 1700 với kiến trúc hoàn toàn mới, mang đến cho bộ PC hiệu năng vượt trội so với thế hệ tiền nhiệm.Bộ vi xử lý cao cấp sở hữu cấu trúc lên đến 12 nhân và 20 luồng, với sức mạnh được phân bổ vào Performance-cores và Efficient-cores. Bộ nhớ đệm 25MB và dung lượng bộ nhớ ấn tượng 128GB, tích hợp bộ nhớ kênh đôi DDR4 3200 MT/s, DDR5 4800 MT/s, giúp hệ thống máy tính đạt được hiệu suất đáng kinh ngạc để các trải nghiệm trở nên mượt mà hơn.

', 5, 9990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (18, N'Thùng máy/ Case Sama S1 (No Power)', N'/app/img/sanpham/cases1.png', N'Các sản phẩm của Sama gồm có vỏ case và PSU với các loại sản phẩm có chất lượng và giá thành từ thấp tới cao. Để hướng tới đối tượng người dùng phân khúc phổ thông hãng đã trình làng dòng sản phẩm thùng máy / Case Sama S series với bộ 6 sản phẩm S1, S2, S3, S4, S5, S6. Trong bài viết này Phong vũ xin giới thiệu đến các bạn thùng máy/ Case Sama S1.', 9, 490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (19, N'Card màn hình ASUS TUF Gaming GeForce GTX 1660 SUPER OC', N'/app/img/sanpham/card1660.png', N'Update', 11, 4990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (20, N'Quạt 8cm', N'/app/img/sanpham/fan8cm.png', N'Trong khi hoạt động, bộ vi xử lý sẽ sinh ra một lượng nhiệt khá lớn, bạn có thể hiểu rằng CPU hoạt động càng mạnh thì nhiệt lượng nó tỏa ra càng lớn. Nếu như không có biện pháp làm mát kịp thời để làm mát thì CPU sẽ giảm hiệu năng xử lý khiến máy tính hoạt động trì trệ hơn. Nghiêm trọng hơn còn khiến máy tính không thể sử dụng được và nguy cơ cháy nổ tăng cao. Quạt CPU được dùng để xử lý thoát nhiệt cho hệ thống CPU máy tính trong quá trình sử dụng.', 10, 13000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (21, N'Quạt 120E', N'/app/img/sanpham/fan120e.png', N'Mô tả sản phẩm sẽ được cập nhật trong thời gian sớm nhất !', 10, 60000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (22, N'RAM desktop KINGSTON Fury Beast (1 x 8GB) DDR4 3200MHz', N'/app/img/sanpham/ram8gb3200.png', N'Ram Desktop Kingston Fury là một trong những dòng Ram phổ thông nhắm đến hiệu năng và giá bán được nhiều khách hàng tin dùng. Phiên bản Kingston Fury mới đã được thay đổi nhẹ về thiết kế để bắt mắt hơn, thu hút người dùng hơn. 
Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury đã được thiết kế để Plug N Play: Cắm là chạy! Hệ thống sẽ được tự động nhận diện bus RAM cao nhất có thể. 

Ram Desktop Kingston Fury Beast 8GB| Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury được sở hữu thiết kế tản nhiệt nhôm đơn giản nhưng đã đem lại hiệu quả tốt cho hầu hết các tác vụ từ cơ bản đến nâng cao của người dùng. 

Hiệu năng mạnh mẽ
Ram Desktop Kingston Fury là một nâng cấp hoàn hảo cho bất kỳ hệ thống máy tính nào, giúp máy tính của bạn có thể thoát khỏi tình trạng chậm, lag do thiếu RAM, mọi hoạt động trên máy tính của bạn trở nên dễ dàng và nhanh chóng hơn trước đây.

Ram Desktop Kingston Fury Beast 8GB| Hiệu năng mạnh mẽ
Tương thích với Intel XMP
Ram Desktop Kingston Fury đã được thiết kế để tương thích hoàn hảo với công nghệ Intel XMP. Thuộc thế hệ DDR4, BUS 3200MHz, Ram Desktop Kingston Fury phù hợp với một dòng Ram phổ thông, đem lại những tính năng cơ bản phục vụ cho người sử dụng.

Ram Desktop Kingston Fury Beast 8GB| Tương thích với công nghệ hiện đại 
Hoạt động một cách hoàn hảo cùng hệ thống AMD Ryzen 
Ram Desktop Kingston Fury đã được kiểm tra toàn diện để có thể hoạt động hoàn hảo cho hệ thống sử dụng CPU AMD Ryzen. Với timing là 16, voltage 1.2 V, Ram Desktop Kingston Fury hoạt động hiệu quả và dễ dàng tiếp cận với người dùng.

Ram Desktop Kingston Fury Beast 8GB| Hoạt động êm ái
Phong Vũ cam kết bán hàng chính hãng và bảo hành sản phẩm lên đến 36 tháng
RAM desktop KINGSTON Fury với bộ nhớ 8GB là một trong những dòng Ram phổ thông, dễ dàng để tiếp cận với nhiều đối tượng khách hàng khác nhau khi nó hoạt động với hiệu năng mạnh mẽ, dễ lắp đặt và sử dụng. Phong Vũ cam kết bán hàng chính hãng của thương hiệu KINGSTON và bảo hành sản phẩm lên đến 36 tháng.', 3, 859000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (23, N'Mainboard ASUS PRIME H510M-K', N'/app/img/sanpham/mainh510m.png', N'Mainboard ASUS PRIME H510M-K có thiết kế năng lượng mạnh mẽ, nó sẽ là giải pháp tản nhiệt hoàn thiện với các tùy chọn điều chỉnh thông minh. ASUS PRIME sẽ mang đến cho người dùng thông thường và người thích tự ráp máy PC một loạt tùy chọn điều chỉnh hiệu năng.
Tự hiệu chỉnh theo cách riêng
Nền tảng của dòng ASUS Prime là được tạo nên nhờ khả năng điều khiển toàn diện. Mainboard Prime H510-K đã tích hợp các công cụ linh hoạt để có thể hiệu chỉnh mọi thông số trong hệ thống. Nó cho phép bạn điều chỉnh hiệu năng để phù hợp với phong cách làm việc của bạn, nhằm tối đa được hoàn hảo năng suất.', 12, 1690000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (24, N'Nguồn máy tính GIGABYTE P650B - 650W - 80 Plus Bronze', N'/app/img/sanpham/psup650b.png', N'Gigabyte P650B là một trong những bộ Nguồn máy tính tầm trung đầu tiên của Gigabyte được tung ra thị trường, được hướng tới những người sử dụng sở hữu 1 cấu hình tầm trung nhưng cần có một bộ Nguồn máy tính mạnh mẽ để có thể nâng cấp phần cứng về sau.

Với công suất tổng 650W, chắc chắn Gigabyte P650B sẽ đảm bảo cho hầu hết các cấu hình Máy tính tầm trung ở thời điểm hiện tại hoạt động 1 cách ổn định, thâm chí là đối với các cấu hình cao cấp. Toàn bộ tụ điện được sử dụng bên trong Gigabyte P650B đều được sản xuất từ Nhật Bản nhằm đảm bảo tuổi thọ hoạt động một cách tối ưu nhất.', 6, 1339000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (25, N'Tai nghe DareU EH416 RGB (Đen)', N'/app/img/sanpham/taingheeh416.png', N'Thông số kĩ thuật của Tai nghe DareU EH416 RGB (Đen):

Giả lập 7.1: Có
Mút đệm: Gia nhân tạo
Cổng kết nối: USB
Chất liệu Band: Kim loại
Tần số: 20 – 20.000 Hz
Độ dài dây: 2m
Cân nặng: 280g
Led: RGB
Drive: 50mm', 13, 379000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (26, N'Laptop Lenovo Slim 7 Pro 14IHU5 O', N'/app/img/sanpham/laptoplenovo.png', N'Laptop Lenovo Yoga Slim 7 Pro 14IHU5 O-82NH00BCVN sở hữu vẻ ngoài đơn giản nhưng không kém phần hiện đại, chắc chắn sẽ làm hài lòng kể cả những khách hàng khó tính về thiết kế, không những thế, bên trong chiếc máy tính này đáp ứng hiệu năng ổn định đến từ CPU Intel Core i5 Gen 11 và chip đồ họa Intel Iris Xe Graphics. Hãy cùng Phong Vũ điểm qua một số tính năng nổi bật của sản phẩm này nhé.', 2, 20190000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (27, N'bbbbb', N'/app/img/sanpham/laptop acer 3.png', N'assss', 10, 555555)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (28, N'MacBook Pro 2018 13.3 inch MR9R2', N'/app/img/sanpham/mac2018.png', N'MacBook Pro nâng tầm khái niệm notebook lên một tầm cao mới, với hiệu năng và tính di động chuẩn mực. Cùng phác họa và phát triển ý tưởng của bạn nhanh hơn bao giờ hết, nhờ có sự hỗ trợ của vi xử lý hiệu năng cao cùng với bộ nhớ, dung lượng lưu trữ và đồ họa tân tiến. Với bộ xử lý Intel Core thế hệ thứ tám, MacBook Pro đạt đến tầm cao mới về hiệu năng tính toán. Model 15 inch hiện có bộ xử lý Intel Core i9 6 nhân, hoạt động nhanh hơn tới 70% so với thế hệ trước, cho phép tốc độ Turbo Boost lên tới 4,8 GHz. 

Trong khi đó, bộ xử lý lõi tứ trên Apple MacBook Pro 13.3” MR9R2 với Touch Bar giờ đây giúp nó nhanh gấp đôi so với thế hệ trước. Vì vậy, khi thực hiện các công việc xử lý cấp độ như biên dịch mã, kết xuất mô hình 3D, thêm hiệu ứng đặc biệt, xếp lớp nhiều bản nhạc hoặc mã hóa video, bạn sẽ hoàn thành mọi việc với tốc độ nhanh hơn.', 1, 24945000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (29, N'PC APPLE iMac Z0ZX 27"5K/Intel Core i7/16GB/512GBSSD', N'/app/img/sanpham/imac275k.png', N'Update', 1, 49000000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (30, N'Máy tính để bàn - PC Acer Aspire AS-XC780 DT.B8ASV.006', N'/app/img/sanpham/pc1.png', N'Máy bộ Acer Aspire XC-780 DT.B8ASV.006 được thiết kế nhỏ gọn, giúp bạn tiết kiệm nhiều không gian, bạn có thể dễ dàng đặt nó dưới chân bàn để tiết kiệm diện tích. Bên cạnh đó với thiết kế đẹp với tông màu đen, sản phẩm còn giúp căn phòng làm việc của bạn trở nên hoàn hảo, chuyên nghiệp hơn. Với bộ vi xử lý Intel Core i5 7400 3.00 GHz up to 3.50 GHz, 6MB, dung lượng RAM 4GB cùng card đồ họa NVIDIA GeForce GT 720 2GB, máy thực hiện tốt các ứng dụng văn phòng, hỗ trợ đa nhiệm tốt. Ổ cứng có dung lượng 1TB để bạn có thể lưu trữ được nhiều dữ liệu hơn. 

Máy bộ Acer Aspire XC-780 DT.B8ASV.006 cũng được trang bị đầy đủ các cổng giao tiếp, kết nối để chia sẽ dữ liệu và kết nối với các thiết bị ngoại vi. Ngoài ra sản phẩm cũng được tích hợp wifi để người dùng dễ dàng truy cập internet', 14, 11499000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (31, N'Máy tính để bàn - PC Dell Inspiron 3470 SFF STI51315', N'/app/img/sanpham/pc2.png', N'(i5-8400/8GB/1TB HDD/UHD 630/Ubuntu)', 14, 12490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (32, N'Màn hình LCD MSI Optix G27C7', N'/app/img/sanpham/lcdmsi.png', N'Update', 7, 5490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (33, N'Màn hình LCD Lenovo D22e-20', N'/app/img/sanpham/lcdlenovo.png', N'(1920 x 1080/VA/75Hz/4 ms/FreeSync) Màn hình LCD Lenovo D22e-20 được đánh giá là dòng màn hình thông minh vượt trội nhất hiện nay, Lenovo đã cho ra mắt Màn hình LCD Lenovo D22e-20 với nhiều sự cải tiến cả về diện mạo lẫn chất lượng để đáp ứng  được đầy đủ về nhu cầu sử dụng cao cấp của người tiêu dùng hiện nay, hứa hẹn sẽ mang lại những trải nghiệm thú vị, cho bạn cái nhìn hoàn thiện hơn.', 7, 2490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (34, N'HDD WD Black P10 Game Drive 2TB USB3.2', N'/app/img/sanpham/hddp102tb.png', N'Bộ nhớ di động cho bộ sưu tập trò chơi tuyệt vời của bạn
Ổ đĩa trò chơi WD_BLACK ™ P10 cung cấp cho bảng điều khiển hoặc PC của bạn các công cụ nâng cao hiệu suất cần thiết để giữ lợi thế cạnh tranh của bạn. Đây là ổ cứng gắn ngoài hàng đầu với dung lượng lên tới 5TB, được chế tạo dành riêng cho các game thủ muốn mở rộng tiềm năng của bảng điều khiển hoặc PC bằng cách lưu thư viện trò chơi của họ theo hình thức di chuyển. Giờ đây, với Ổ đĩa trò chơi WD_BLACK ™ P10, bạn có thể lái trò chơi của mình theo cách bạn chọn.

Mở rộng vương quốc của bạn
Khi thư viện trò chơi của bạn phát triển, bạn sẽ cần không gian để lưu các tựa game quý giá mới của mình, cùng với phòng trống để lưu các mục yêu thích cũ của bạn. Ổ đĩa trò chơi WD_BLACK ™ P10 có dung lượng lên tới 5TB có thể lưu tới 125 trò chơi 3 , do đó bạn không phải thỏa hiệp những trò chơi nào cần xóa trên bảng điều khiển hoặc PC để có chỗ cho những trò chơi mới.

Bất cứ nơi nào bạn đi, trò chơi của bạn
Theo dõi nhanh chóng vào trò chơi, bất kể bạn đang ở đâu. Yếu tố hình thức dễ dàng di động và độ bền cao của WD_BLACK ™ P10 mang đến cho bạn khả năng mang thư viện bên mình mọi lúc mọi nơi. Chỉ cần cắm, đăng nhập và bạn đã sẵn sàng chơi bất kỳ trò chơi nào trong bộ sưu tập 4 bạn mong muốn .

Được xây dựng để tốt hơn
Mọi thứ đi vào các thiết bị WD_BLACK ™ được thiết kế đặc biệt để đưa trò chơi của bạn đi xa hơn, bất kể bạn chơi gì. Với tốc độ lên tới 140MB / s 2 và tối đa 5TB 1 dung lượng lưu trữ bổ sung, Ổ đĩa trò chơi WD_BLACK ™ P10 sẽ đẩy bảng điều khiển hoặc PC của bạn lên mức hiệu suất mới, cho phép bạn lái trò chơi và chơi mà không bị giới hạn.

Thắng mà không phải lo lắng
WD_BLACK ™ đang phá vỡ khuôn mẫu khi nói đến hiệu suất và mở rộng lưu trữ cao cấp. Được xây dựng có mục đích cho các game thủ, WD_BLACK ™ P10 Game Drive mang đến cho bảng điều khiển hoặc PC của bạn khả năng tăng cường hiệu suất đáng tin cậy, đáng tin cậy và cần có, vì vậy bạn sẽ mất ít thời gian hơn để lo lắng về phần cứng của mình và giành được nhiều thời gian hơn', 4, 3039000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (35, N'CPU INTEL Core i7-12700 (12C/20T, 4.90 GHz, 25MB) - 1700', N'/app/img/sanpham/corei712700.png', N'CPU Intel Core i7 12700 là một trong những CPU dòng Alder Lake cao cấp có sức mạnh phân bổ hiệu quả, mang đến hiệu năng vượt trội để bạn có trải nghiệm mượt mà hơn bao giờ hết. Core i7 12700 cao cấp hứa hẹn sẽ là trợ thủ đắc lực giúp bạn nâng cấp cấu hình dàn PC hiện tại của mình. 
Tính tương thích cao, cấu trúc 12 nhân 20 luồng mạnh mẽ
CPU Intel Core i7 12700 có thể chạy được trên nhiều bo mạch chủ như H610, B660, H670 hay Z690 và tương thích với socket LGA 1700 thế hệ mới. CPU thế hệ thứ 12 trên nền socket LGA 1700 với kiến trúc hoàn toàn mới, mang đến cho bộ PC hiệu năng vượt trội so với thế hệ tiền nhiệm.Bộ vi xử lý cao cấp sở hữu cấu trúc lên đến 12 nhân và 20 luồng, với sức mạnh được phân bổ vào Performance-cores và Efficient-cores. Bộ nhớ đệm 25MB và dung lượng bộ nhớ ấn tượng 128GB, tích hợp bộ nhớ kênh đôi DDR4 3200 MT/s, DDR5 4800 MT/s, giúp hệ thống máy tính đạt được hiệu suất đáng kinh ngạc để các trải nghiệm trở nên mượt mà hơn.

', 5, 9990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (36, N'Thùng máy/ Case Sama S1 (No Power)', N'/app/img/sanpham/cases1.png', N'Các sản phẩm của Sama gồm có vỏ case và PSU với các loại sản phẩm có chất lượng và giá thành từ thấp tới cao. Để hướng tới đối tượng người dùng phân khúc phổ thông hãng đã trình làng dòng sản phẩm thùng máy / Case Sama S series với bộ 6 sản phẩm S1, S2, S3, S4, S5, S6. Trong bài viết này Phong vũ xin giới thiệu đến các bạn thùng máy/ Case Sama S1.', 9, 490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (37, N'Card màn hình ASUS TUF Gaming GeForce GTX 1660 SUPER OC Edition 6GB GDDR6 TUF-GTX1660S-O6G-GAMING', N'/app/img/sanpham/card1660.png', N'Update', 11, 4990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (38, N'Quạt 8cm', N'/app/img/sanpham/fan8cm.png', N'Trong khi hoạt động, bộ vi xử lý sẽ sinh ra một lượng nhiệt khá lớn, bạn có thể hiểu rằng CPU hoạt động càng mạnh thì nhiệt lượng nó tỏa ra càng lớn. Nếu như không có biện pháp làm mát kịp thời để làm mát thì CPU sẽ giảm hiệu năng xử lý khiến máy tính hoạt động trì trệ hơn. Nghiêm trọng hơn còn khiến máy tính không thể sử dụng được và nguy cơ cháy nổ tăng cao. Quạt CPU được dùng để xử lý thoát nhiệt cho hệ thống CPU máy tính trong quá trình sử dụng.', 10, 13000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (39, N'Quạt 120E', N'/app/img/sanpham/fan120e.png', N'Mô tả sản phẩm sẽ được cập nhật trong thời gian sớm nhất !', 10, 60000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (40, N'RAM desktop KINGSTON Fury Beast (1 x 8GB) DDR4 3200MHz', N'/app/img/sanpham/ram8gb3200.png', N'Ram Desktop Kingston Fury là một trong những dòng Ram phổ thông nhắm đến hiệu năng và giá bán được nhiều khách hàng tin dùng. Phiên bản Kingston Fury mới đã được thay đổi nhẹ về thiết kế để bắt mắt hơn, thu hút người dùng hơn. 
Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury đã được thiết kế để Plug N Play: Cắm là chạy! Hệ thống sẽ được tự động nhận diện bus RAM cao nhất có thể. 

Ram Desktop Kingston Fury Beast 8GB| Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury được sở hữu thiết kế tản nhiệt nhôm đơn giản nhưng đã đem lại hiệu quả tốt cho hầu hết các tác vụ từ cơ bản đến nâng cao của người dùng. 

Hiệu năng mạnh mẽ
Ram Desktop Kingston Fury là một nâng cấp hoàn hảo cho bất kỳ hệ thống máy tính nào, giúp máy tính của bạn có thể thoát khỏi tình trạng chậm, lag do thiếu RAM, mọi hoạt động trên máy tính của bạn trở nên dễ dàng và nhanh chóng hơn trước đây.

Ram Desktop Kingston Fury Beast 8GB| Hiệu năng mạnh mẽ
Tương thích với Intel XMP
Ram Desktop Kingston Fury đã được thiết kế để tương thích hoàn hảo với công nghệ Intel XMP. Thuộc thế hệ DDR4, BUS 3200MHz, Ram Desktop Kingston Fury phù hợp với một dòng Ram phổ thông, đem lại những tính năng cơ bản phục vụ cho người sử dụng.

Ram Desktop Kingston Fury Beast 8GB| Tương thích với công nghệ hiện đại 
Hoạt động một cách hoàn hảo cùng hệ thống AMD Ryzen 
Ram Desktop Kingston Fury đã được kiểm tra toàn diện để có thể hoạt động hoàn hảo cho hệ thống sử dụng CPU AMD Ryzen. Với timing là 16, voltage 1.2 V, Ram Desktop Kingston Fury hoạt động hiệu quả và dễ dàng tiếp cận với người dùng.

Ram Desktop Kingston Fury Beast 8GB| Hoạt động êm ái
Phong Vũ cam kết bán hàng chính hãng và bảo hành sản phẩm lên đến 36 tháng
RAM desktop KINGSTON Fury với bộ nhớ 8GB là một trong những dòng Ram phổ thông, dễ dàng để tiếp cận với nhiều đối tượng khách hàng khác nhau khi nó hoạt động với hiệu năng mạnh mẽ, dễ lắp đặt và sử dụng. Phong Vũ cam kết bán hàng chính hãng của thương hiệu KINGSTON và bảo hành sản phẩm lên đến 36 tháng.', 3, 859000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (41, N'Mainboard ASUS PRIME H510M-K', N'/app/img/sanpham/mainh510m.png', N'Mainboard ASUS PRIME H510M-K có thiết kế năng lượng mạnh mẽ, nó sẽ là giải pháp tản nhiệt hoàn thiện với các tùy chọn điều chỉnh thông minh. ASUS PRIME sẽ mang đến cho người dùng thông thường và người thích tự ráp máy PC một loạt tùy chọn điều chỉnh hiệu năng.
Tự hiệu chỉnh theo cách riêng
Nền tảng của dòng ASUS Prime là được tạo nên nhờ khả năng điều khiển toàn diện. Mainboard Prime H510-K đã tích hợp các công cụ linh hoạt để có thể hiệu chỉnh mọi thông số trong hệ thống. Nó cho phép bạn điều chỉnh hiệu năng để phù hợp với phong cách làm việc của bạn, nhằm tối đa được hoàn hảo năng suất.', 12, 1690000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (42, N'Nguồn máy tính GIGABYTE P650B - 650W - 80 Plus Bronze', N'/app/img/sanpham/psup650b.png', N'Gigabyte P650B là một trong những bộ Nguồn máy tính tầm trung đầu tiên của Gigabyte được tung ra thị trường, được hướng tới những người sử dụng sở hữu 1 cấu hình tầm trung nhưng cần có một bộ Nguồn máy tính mạnh mẽ để có thể nâng cấp phần cứng về sau.

Với công suất tổng 650W, chắc chắn Gigabyte P650B sẽ đảm bảo cho hầu hết các cấu hình Máy tính tầm trung ở thời điểm hiện tại hoạt động 1 cách ổn định, thâm chí là đối với các cấu hình cao cấp. Toàn bộ tụ điện được sử dụng bên trong Gigabyte P650B đều được sản xuất từ Nhật Bản nhằm đảm bảo tuổi thọ hoạt động một cách tối ưu nhất.', 6, 1339000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (43, N'Tai nghe DareU EH416 RGB (Đen)', N'/app/img/sanpham/taingheeh416.png', N'Thông số kĩ thuật của Tai nghe DareU EH416 RGB (Đen):

Giả lập 7.1: Có
Mút đệm: Gia nhân tạo
Cổng kết nối: USB
Chất liệu Band: Kim loại
Tần số: 20 – 20.000 Hz
Độ dài dây: 2m
Cân nặng: 280g
Led: RGB
Drive: 50mm', 13, 379000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (44, N'MacBook Pro 2018 13.3 inch MR9R2', N'/app/img/sanpham/mac2018.png', N'MacBook Pro nâng tầm khái niệm notebook lên một tầm cao mới, với hiệu năng và tính di động chuẩn mực. Cùng phác họa và phát triển ý tưởng của bạn nhanh hơn bao giờ hết, nhờ có sự hỗ trợ của vi xử lý hiệu năng cao cùng với bộ nhớ, dung lượng lưu trữ và đồ họa tân tiến. Với bộ xử lý Intel Core thế hệ thứ tám, MacBook Pro đạt đến tầm cao mới về hiệu năng tính toán. Model 15 inch hiện có bộ xử lý Intel Core i9 6 nhân, hoạt động nhanh hơn tới 70% so với thế hệ trước, cho phép tốc độ Turbo Boost lên tới 4,8 GHz. 

Trong khi đó, bộ xử lý lõi tứ trên Apple MacBook Pro 13.3” MR9R2 với Touch Bar giờ đây giúp nó nhanh gấp đôi so với thế hệ trước. Vì vậy, khi thực hiện các công việc xử lý cấp độ như biên dịch mã, kết xuất mô hình 3D, thêm hiệu ứng đặc biệt, xếp lớp nhiều bản nhạc hoặc mã hóa video, bạn sẽ hoàn thành mọi việc với tốc độ nhanh hơn.', 1, 24945000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (45, N'PC APPLE iMac Z0ZX 27"5K/Intel Core i7/16GB/512GBSSD', N'/app/img/sanpham/imac275k.png', N'Update', 1, 49000000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (46, N'Máy tính để bàn - PC Acer Aspire AS-XC780 DT.B8ASV.006', N'/app/img/sanpham/pc1.png', N'Máy bộ Acer Aspire XC-780 DT.B8ASV.006 được thiết kế nhỏ gọn, giúp bạn tiết kiệm nhiều không gian, bạn có thể dễ dàng đặt nó dưới chân bàn để tiết kiệm diện tích. Bên cạnh đó với thiết kế đẹp với tông màu đen, sản phẩm còn giúp căn phòng làm việc của bạn trở nên hoàn hảo, chuyên nghiệp hơn. Với bộ vi xử lý Intel Core i5 7400 3.00 GHz up to 3.50 GHz, 6MB, dung lượng RAM 4GB cùng card đồ họa NVIDIA GeForce GT 720 2GB, máy thực hiện tốt các ứng dụng văn phòng, hỗ trợ đa nhiệm tốt. Ổ cứng có dung lượng 1TB để bạn có thể lưu trữ được nhiều dữ liệu hơn. 

Máy bộ Acer Aspire XC-780 DT.B8ASV.006 cũng được trang bị đầy đủ các cổng giao tiếp, kết nối để chia sẽ dữ liệu và kết nối với các thiết bị ngoại vi. Ngoài ra sản phẩm cũng được tích hợp wifi để người dùng dễ dàng truy cập internet', 14, 11499000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (47, N'Máy tính để bàn - PC Dell Inspiron 3470 SFF STI51315', N'/app/img/sanpham/pc2.png', N'(i5-8400/8GB/1TB HDD/UHD 630/Ubuntu)', 14, 12490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (48, N'Màn hình LCD MSI Optix G27C7', N'/app/img/sanpham/lcdmsi.png', N'Update', 7, 5490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (49, N'Màn hình LCD Lenovo D22e-20', N'/app/img/sanpham/lcdlenovo.png', N'(1920 x 1080/VA/75Hz/4 ms/FreeSync) Màn hình LCD Lenovo D22e-20 được đánh giá là dòng màn hình thông minh vượt trội nhất hiện nay, Lenovo đã cho ra mắt Màn hình LCD Lenovo D22e-20 với nhiều sự cải tiến cả về diện mạo lẫn chất lượng để đáp ứng  được đầy đủ về nhu cầu sử dụng cao cấp của người tiêu dùng hiện nay, hứa hẹn sẽ mang lại những trải nghiệm thú vị, cho bạn cái nhìn hoàn thiện hơn.', 7, 2490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (50, N'HDD WD Black P10 Game Drive 2TB USB3.2', N'/app/img/sanpham/hddp102tb.png', N'Bộ nhớ di động cho bộ sưu tập trò chơi tuyệt vời của bạn
Ổ đĩa trò chơi WD_BLACK ™ P10 cung cấp cho bảng điều khiển hoặc PC của bạn các công cụ nâng cao hiệu suất cần thiết để giữ lợi thế cạnh tranh của bạn. Đây là ổ cứng gắn ngoài hàng đầu với dung lượng lên tới 5TB, được chế tạo dành riêng cho các game thủ muốn mở rộng tiềm năng của bảng điều khiển hoặc PC bằng cách lưu thư viện trò chơi của họ theo hình thức di chuyển. Giờ đây, với Ổ đĩa trò chơi WD_BLACK ™ P10, bạn có thể lái trò chơi của mình theo cách bạn chọn.

Mở rộng vương quốc của bạn
Khi thư viện trò chơi của bạn phát triển, bạn sẽ cần không gian để lưu các tựa game quý giá mới của mình, cùng với phòng trống để lưu các mục yêu thích cũ của bạn. Ổ đĩa trò chơi WD_BLACK ™ P10 có dung lượng lên tới 5TB có thể lưu tới 125 trò chơi 3 , do đó bạn không phải thỏa hiệp những trò chơi nào cần xóa trên bảng điều khiển hoặc PC để có chỗ cho những trò chơi mới.

Bất cứ nơi nào bạn đi, trò chơi của bạn
Theo dõi nhanh chóng vào trò chơi, bất kể bạn đang ở đâu. Yếu tố hình thức dễ dàng di động và độ bền cao của WD_BLACK ™ P10 mang đến cho bạn khả năng mang thư viện bên mình mọi lúc mọi nơi. Chỉ cần cắm, đăng nhập và bạn đã sẵn sàng chơi bất kỳ trò chơi nào trong bộ sưu tập 4 bạn mong muốn .

Được xây dựng để tốt hơn
Mọi thứ đi vào các thiết bị WD_BLACK ™ được thiết kế đặc biệt để đưa trò chơi của bạn đi xa hơn, bất kể bạn chơi gì. Với tốc độ lên tới 140MB / s 2 và tối đa 5TB 1 dung lượng lưu trữ bổ sung, Ổ đĩa trò chơi WD_BLACK ™ P10 sẽ đẩy bảng điều khiển hoặc PC của bạn lên mức hiệu suất mới, cho phép bạn lái trò chơi và chơi mà không bị giới hạn.

Thắng mà không phải lo lắng
WD_BLACK ™ đang phá vỡ khuôn mẫu khi nói đến hiệu suất và mở rộng lưu trữ cao cấp. Được xây dựng có mục đích cho các game thủ, WD_BLACK ™ P10 Game Drive mang đến cho bảng điều khiển hoặc PC của bạn khả năng tăng cường hiệu suất đáng tin cậy, đáng tin cậy và cần có, vì vậy bạn sẽ mất ít thời gian hơn để lo lắng về phần cứng của mình và giành được nhiều thời gian hơn', 4, 3039000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (51, N'CPU INTEL Core i7-12700 (12C/20T, 4.90 GHz, 25MB) - 1700', N'/app/img/sanpham/corei712700.png', N'CPU Intel Core i7 12700 là một trong những CPU dòng Alder Lake cao cấp có sức mạnh phân bổ hiệu quả, mang đến hiệu năng vượt trội để bạn có trải nghiệm mượt mà hơn bao giờ hết. Core i7 12700 cao cấp hứa hẹn sẽ là trợ thủ đắc lực giúp bạn nâng cấp cấu hình dàn PC hiện tại của mình. 
Tính tương thích cao, cấu trúc 12 nhân 20 luồng mạnh mẽ
CPU Intel Core i7 12700 có thể chạy được trên nhiều bo mạch chủ như H610, B660, H670 hay Z690 và tương thích với socket LGA 1700 thế hệ mới. CPU thế hệ thứ 12 trên nền socket LGA 1700 với kiến trúc hoàn toàn mới, mang đến cho bộ PC hiệu năng vượt trội so với thế hệ tiền nhiệm.Bộ vi xử lý cao cấp sở hữu cấu trúc lên đến 12 nhân và 20 luồng, với sức mạnh được phân bổ vào Performance-cores và Efficient-cores. Bộ nhớ đệm 25MB và dung lượng bộ nhớ ấn tượng 128GB, tích hợp bộ nhớ kênh đôi DDR4 3200 MT/s, DDR5 4800 MT/s, giúp hệ thống máy tính đạt được hiệu suất đáng kinh ngạc để các trải nghiệm trở nên mượt mà hơn.

', 5, 9990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (52, N'Thùng máy/ Case Sama S1 (No Power)', N'/app/img/sanpham/cases1.png', N'Các sản phẩm của Sama gồm có vỏ case và PSU với các loại sản phẩm có chất lượng và giá thành từ thấp tới cao. Để hướng tới đối tượng người dùng phân khúc phổ thông hãng đã trình làng dòng sản phẩm thùng máy / Case Sama S series với bộ 6 sản phẩm S1, S2, S3, S4, S5, S6. Trong bài viết này Phong vũ xin giới thiệu đến các bạn thùng máy/ Case Sama S1.', 9, 490000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (53, N'Card màn hình ASUS TUF Gaming GeForce GTX 1660 SUPER OC Edition 6GB GDDR6 TUF-GTX1660S-O6G-GAMING', N'/app/img/sanpham/card1660.png', N'Update', 11, 4990000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (54, N'Quạt 8cm', N'/app/img/sanpham/fan8cm.png', N'Trong khi hoạt động, bộ vi xử lý sẽ sinh ra một lượng nhiệt khá lớn, bạn có thể hiểu rằng CPU hoạt động càng mạnh thì nhiệt lượng nó tỏa ra càng lớn. Nếu như không có biện pháp làm mát kịp thời để làm mát thì CPU sẽ giảm hiệu năng xử lý khiến máy tính hoạt động trì trệ hơn. Nghiêm trọng hơn còn khiến máy tính không thể sử dụng được và nguy cơ cháy nổ tăng cao. Quạt CPU được dùng để xử lý thoát nhiệt cho hệ thống CPU máy tính trong quá trình sử dụng.', 10, 13000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (55, N'Quạt 120E', N'/app/img/sanpham/fan120e.png', N'Mô tả sản phẩm sẽ được cập nhật trong thời gian sớm nhất !', 10, 60000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (56, N'RAM desktop KINGSTON Fury Beast (1 x 8GB) DDR4 3200MHz', N'/app/img/sanpham/ram8gb3200.png', N'Ram Desktop Kingston Fury là một trong những dòng Ram phổ thông nhắm đến hiệu năng và giá bán được nhiều khách hàng tin dùng. Phiên bản Kingston Fury mới đã được thay đổi nhẹ về thiết kế để bắt mắt hơn, thu hút người dùng hơn. 
Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury đã được thiết kế để Plug N Play: Cắm là chạy! Hệ thống sẽ được tự động nhận diện bus RAM cao nhất có thể. 

Ram Desktop Kingston Fury Beast 8GB| Thiết kế, lắp đặt đơn giản
Ram Desktop Kingston Fury được sở hữu thiết kế tản nhiệt nhôm đơn giản nhưng đã đem lại hiệu quả tốt cho hầu hết các tác vụ từ cơ bản đến nâng cao của người dùng. 

Hiệu năng mạnh mẽ
Ram Desktop Kingston Fury là một nâng cấp hoàn hảo cho bất kỳ hệ thống máy tính nào, giúp máy tính của bạn có thể thoát khỏi tình trạng chậm, lag do thiếu RAM, mọi hoạt động trên máy tính của bạn trở nên dễ dàng và nhanh chóng hơn trước đây.

Ram Desktop Kingston Fury Beast 8GB| Hiệu năng mạnh mẽ
Tương thích với Intel XMP
Ram Desktop Kingston Fury đã được thiết kế để tương thích hoàn hảo với công nghệ Intel XMP. Thuộc thế hệ DDR4, BUS 3200MHz, Ram Desktop Kingston Fury phù hợp với một dòng Ram phổ thông, đem lại những tính năng cơ bản phục vụ cho người sử dụng.

Ram Desktop Kingston Fury Beast 8GB| Tương thích với công nghệ hiện đại 
Hoạt động một cách hoàn hảo cùng hệ thống AMD Ryzen 
Ram Desktop Kingston Fury đã được kiểm tra toàn diện để có thể hoạt động hoàn hảo cho hệ thống sử dụng CPU AMD Ryzen. Với timing là 16, voltage 1.2 V, Ram Desktop Kingston Fury hoạt động hiệu quả và dễ dàng tiếp cận với người dùng.

Ram Desktop Kingston Fury Beast 8GB| Hoạt động êm ái
Phong Vũ cam kết bán hàng chính hãng và bảo hành sản phẩm lên đến 36 tháng
RAM desktop KINGSTON Fury với bộ nhớ 8GB là một trong những dòng Ram phổ thông, dễ dàng để tiếp cận với nhiều đối tượng khách hàng khác nhau khi nó hoạt động với hiệu năng mạnh mẽ, dễ lắp đặt và sử dụng. Phong Vũ cam kết bán hàng chính hãng của thương hiệu KINGSTON và bảo hành sản phẩm lên đến 36 tháng.', 3, 859000)
INSERT [dbo].[Product] ([id], [name], [image], [descriptions], [categoryId], [price]) VALUES (57, N'Mainboard ASUS PRIME H510M-K', N'/app/img/sanpham/mainh510m.png', N'Mainboard ASUS PRIME H510M-K có thiết kế năng lượng mạnh mẽ, nó sẽ là giải pháp tản nhiệt hoàn thiện với các tùy chọn điều chỉnh thông minh. ASUS PRIME sẽ mang đến cho người dùng thông thường và người thích tự ráp máy PC một loạt tùy chọn điều chỉnh hiệu năng.
Tự hiệu chỉnh theo cách riêng
Nền tảng của dòng ASUS Prime là được tạo nên nhờ khả năng điều khiển toàn diện. Mainboard Prime H510-K đã tích hợp các công cụ linh hoạt để có thể hiệu chỉnh mọi thông số trong hệ thống. Nó cho phép bạn điều chỉnh hiệu năng để phù hợp với phong cách làm việc của bạn, nhằm tối đa được hoàn hảo năng suất.', 12, 1690000)
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
INSERT [dbo].[User] ([Email], [Password], [Name], [Phone], [Address], [ResetPasswordCode]) VALUES (N'congdo2603@gmail.com', N'E10ADC3949BA59ABBE56E057F20F883E', N'Đỗ Quốc Công', N'0977758570', N'Man Thiện', NULL)
INSERT [dbo].[User] ([Email], [Password], [Name], [Phone], [Address], [ResetPasswordCode]) VALUES (N'cuongnguyenc.n1612@gmail.com', N'E10ADC3949BA59ABBE56E057F20F883E', N'Nguyễn tân Quốc Cường', N'0935268359', N'618/61/46 Quang Trung, P.11, Q.Gò Vấp, TP.HCM', N'')
INSERT [dbo].[User] ([Email], [Password], [Name], [Phone], [Address], [ResetPasswordCode]) VALUES (N'jacknhoxdx2@gmail.com', N'E10ADC3949BA59ABBE56E057F20F883E', N'asd··', N'123', N'123', NULL)
INSERT [dbo].[User] ([Email], [Password], [Name], [Phone], [Address], [ResetPasswordCode]) VALUES (N'nguyenhoangminh24122001@gmail.com', N'41525AF98CFFE913D396C83BDD493181', N'Minh', N'0984517852', N'Quan 4', N'dbf174be-3be2-4e06-812f-0183f863c2ad')
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK_Bill_User] FOREIGN KEY([Email])
REFERENCES [dbo].[User] ([Email])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK_Bill_User]
GO
ALTER TABLE [dbo].[BillDetails]  WITH CHECK ADD  CONSTRAINT [FK_BillDetails_Bill] FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([idBill])
GO
ALTER TABLE [dbo].[BillDetails] CHECK CONSTRAINT [FK_BillDetails_Bill]
GO
ALTER TABLE [dbo].[BillDetails]  WITH CHECK ADD  CONSTRAINT [FK_BillDetails_Product] FOREIGN KEY([id])
REFERENCES [dbo].[Product] ([id])
GO
ALTER TABLE [dbo].[BillDetails] CHECK CONSTRAINT [FK_BillDetails_Product]
GO
ALTER TABLE [dbo].[Product]  WITH NOCHECK ADD  CONSTRAINT [FK_Product_Categories] FOREIGN KEY([categoryId])
REFERENCES [dbo].[Categories] ([id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Categories]
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCart_Product] FOREIGN KEY([id])
REFERENCES [dbo].[Product] ([id])
GO
ALTER TABLE [dbo].[ShoppingCart] CHECK CONSTRAINT [FK_ShoppingCart_Product]
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCart_User] FOREIGN KEY([Email])
REFERENCES [dbo].[User] ([Email])
GO
ALTER TABLE [dbo].[ShoppingCart] CHECK CONSTRAINT [FK_ShoppingCart_User]
GO
USE [master]
GO
ALTER DATABASE [CCS] SET  READ_WRITE 
GO
