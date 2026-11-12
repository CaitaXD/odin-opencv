package opencv

// --- Core structs ---
Mat :: struct #align(8) {
	flags:     i32,
	dims:      i32,
	rows:      i32,
	cols:      i32,
	dummy:     i32,
	_pad0:     i32,
	data:      [^]u8,
	datastart: [^]u8,
	dataend:   [^]u8,
	datalimit: [^]u8,
	allocator: rawptr,
	u:         rawptr,
	size:      [52]u8,
	_pad1:     [4]u8,
	step:      [80]u8,
}

VideoCapture :: struct #align(8) {
	vtable:        rawptr,
	icap:          [16]u8,
	throw_on_fail: bool,
	_pad:          [7]u8,
}

VideoWriter :: struct #align(8) {
	_data: [64]u8,
}

#assert(size_of(Mat) == 208)
#assert(size_of(VideoCapture) == 32)

// --- Border types ---
BorderType :: enum i32 {
	CONSTANT    = 0,
	REPLICATE   = 1,
	REFLECT     = 2,
	WRAP        = 3,
	REFLECT_101 = 4,
	DEFAULT     = 4,
	TRANSPARENT = 5,
	ISOLATED    = 16,
}

// --- Window flags ---
WindowFlags :: enum i32 {
	NORMAL       = 0x00000000,
	AUTOSIZE     = 0x00000001,
	OPENGL       = 0x00001000,
	FULLSCREEN   = 1,
	FREERATIO    = 0x00000100,
	KEEPRATIO    = 0x00000000,
	GUI_EXPANDED = 0x00000000,
	GUI_NORMAL   = 0x00000010,
}

// --- Video capture backends ---
VideoCaptureAPIs :: enum i32 {
	ANY          = 0,
	V4L          = 200,
	V4L2         = 200,
	FIREWIRE     = 300,
	DSHOW        = 700,
	MSMF         = 1400,
	GSTREAMER    = 1800,
	FFMPEG       = 1900,
	IMAGES       = 2000,
	OPENCV_MJPEG = 2200,
}

VideoCaptureAPI :: VideoCaptureAPIs
CAP_ANY  :: VideoCaptureAPIs.ANY
CAP_V4L  :: VideoCaptureAPIs.V4L
CAP_V4L2 :: VideoCaptureAPIs.V4L2

// --- Video capture properties ---
VideoCaptureProperties :: enum i32 {
	POS_MSEC       = 0,
	POS_FRAMES     = 1,
	POS_AVI_RATIO  = 2,
	FRAME_WIDTH    = 3,
	FRAME_HEIGHT   = 4,
	FPS            = 5,
	FOURCC         = 6,
	FRAME_COUNT    = 7,
	FORMAT         = 8,
	MODE           = 9,
	BRIGHTNESS     = 10,
	CONTRAST       = 11,
	SATURATION     = 12,
	HUE            = 13,
	GAIN           = 14,
	EXPOSURE       = 15,
	CONVERT_RGB    = 16,
	AUTO_EXPOSURE  = 21,
	GAMMA          = 22,
	BUFFERSIZE     = 38,
	AUTOFOCUS      = 39,
}

VideoCaptureProperty  :: VideoCaptureProperties
CAP_PROP_FRAME_WIDTH  :: VideoCaptureProperties.FRAME_WIDTH
CAP_PROP_FRAME_HEIGHT :: VideoCaptureProperties.FRAME_HEIGHT
CAP_PROP_FPS          :: VideoCaptureProperties.FPS

// Depth types for Sobel output
DepthType :: enum i32 {
	D8U  = 0,
	D8S  = 1,
	D16U = 2,
	D16S = 3,
	D32F = 5,
	D64F = 6,
}

// Color conversion codes
ColorConversion :: enum i32 {
	GRAY2BGR = 8,
	BGR2GRAY = 6,
}

// Rotate codes
RotateCode :: enum i32 {
	ROTATE_90_CLOCKWISE         = 0,
	ROTATE_180                 = 1,
	ROTATE_90_COUNTERCLOCKWISE = 2,
}

// Flip codes
FlipCode :: enum i32 {
	FLIP_VERTICAL   = 0,
	FLIP_HORIZONTAL = 1,
	FLIP_BOTH       = -1,
}

// --- Qt button types ---
ButtonType :: enum i32 {
	PUSH_BUTTON   = 0,
	CHECKBOX      = 1,
	RADIOBOX      = 2,
	NEW_BUTTONBAR = 1024,
}

ButtonCallback :: #type proc "c" (state: i32, userdata: rawptr)

foreign import lib {
	"libopencv_wrapper.a",
	"system:opencv_core",
	"system:opencv_videoio",
	"system:opencv_highgui",
	"system:opencv_imgproc",
	"system:opencv_imgcodecs",
	"system:stdc++",
}

@(default_calling_convention = "c")
foreign lib {
	// Mat
	@(link_name = "cv_Mat_init")
	mat_init :: proc(ptr: ^Mat) ---

	@(link_name = "cv_Mat_destroy")
	mat_destroy :: proc(ptr: ^Mat) ---

	@(link_name = "cv_Mat_empty")
	mat_empty :: proc(mat: ^Mat) -> bool ---

	// VideoCapture
	@(link_name = "cv_VideoCapture_init")
	video_capture_init :: proc(ptr: ^VideoCapture, index: i32, api_preference: VideoCaptureAPIs = .ANY) ---

	@(link_name = "cv_VideoCapture_init_from_file")
	video_capture_init_from_file :: proc(ptr: ^VideoCapture, filename: cstring, api_preference: VideoCaptureAPIs = .ANY) ---

	@(link_name = "cv_VideoCapture_destroy")
	video_capture_destroy :: proc(ptr: ^VideoCapture) ---

	@(link_name = "cv_VideoCapture_open")
	video_capture_open :: proc(cap: ^VideoCapture, index: i32, api_preference: VideoCaptureAPIs = .ANY) -> bool ---

	@(link_name = "cv_VideoCapture_open_file")
	video_capture_open_file :: proc(cap: ^VideoCapture, filename: cstring, api_preference: VideoCaptureAPIs = .ANY) -> bool ---

	@(link_name = "cv_VideoCapture_release")
	video_capture_release :: proc(cap: ^VideoCapture) ---

	@(link_name = "cv_VideoCapture_isOpened")
	video_capture_is_opened :: proc(cap: ^VideoCapture) -> bool ---

	@(link_name = "cv_VideoCapture_read")
	video_capture_read :: proc(cap: ^VideoCapture, image: ^Mat) -> bool ---

	@(link_name = "cv_VideoCapture_set")
	video_capture_set :: proc(cap: ^VideoCapture, prop_id: VideoCaptureProperties, value: f64) -> bool ---

	@(link_name = "cv_VideoCapture_get")
	video_capture_get :: proc(cap: ^VideoCapture, prop_id: VideoCaptureProperties) -> f64 ---

	// VideoWriter
	@(link_name = "cv_VideoWriter_init")
	video_writer_init :: proc(ptr: ^VideoWriter) ---

	@(link_name = "cv_VideoWriter_init_with_params")
	video_writer_init_with_params :: proc(ptr: ^VideoWriter, filename: cstring, fourcc: i32, fps: f64, width, height: i32, is_color: bool) ---

	@(link_name = "cv_VideoWriter_destroy")
	video_writer_destroy :: proc(ptr: ^VideoWriter) ---

	@(link_name = "cv_VideoWriter_open")
	video_writer_open :: proc(writer: ^VideoWriter, filename: cstring, fourcc: i32, fps: f64, width, height: i32, is_color: bool) -> bool ---

	@(link_name = "cv_VideoWriter_release")
	video_writer_release :: proc(writer: ^VideoWriter) ---

	@(link_name = "cv_VideoWriter_isOpened")
	video_writer_is_opened :: proc(writer: ^VideoWriter) -> bool ---

	@(link_name = "cv_VideoWriter_write")
	video_writer_write :: proc(writer: ^VideoWriter, image: ^Mat) ---

	// HighGUI
	@(link_name = "cv_namedWindow")
	named_window :: proc(winname: cstring, flags: WindowFlags = .AUTOSIZE) ---

	@(link_name = "cv_imshow")
	imshow :: proc(winname: cstring, mat: ^Mat) ---

	@(link_name = "cv_waitKey")
	wait_key :: proc(delay: i32 = 0) -> i32 ---

	@(link_name = "cv_destroyAllWindows")
	destroy_all_windows :: proc() ---

	@(link_name = "cv_destroyWindow")
	destroy_window :: proc(winname: cstring) ---

	@(link_name = "cv_resizeWindow")
	resize_window :: proc(winname: cstring, width, height: i32) ---

	@(link_name = "cv_createTrackbar")
	create_trackbar :: proc(trackbarname, winname: cstring, value: ^i32, count: i32) -> i32 ---

	@(link_name = "cv_getTrackbarPos")
	get_trackbar_pos :: proc(trackbarname, winname: cstring) -> i32 ---

	@(link_name = "cv_setTrackbarPos")
	set_trackbar_pos :: proc(trackbarname, winname: cstring, pos: i32) ---

	@(link_name = "cv_setTrackbarMax")
	set_trackbar_max :: proc(trackbarname, winname: cstring, maxval: i32) ---

	@(link_name = "cv_setTrackbarMin")
	set_trackbar_min :: proc(trackbarname, winname: cstring, minval: i32) ---

	@(link_name = "cv_createButton")
	create_button :: proc(bar_name: cstring, on_change: ButtonCallback, userdata: rawptr = nil, type: ButtonType = .PUSH_BUTTON, initial_button_state: bool = false) -> i32 ---

	// Image Processing
	@(private, link_name = "cv_GaussianBlur")
	_gaussian_blur :: proc(src, dst: ^Mat, ksize_width, ksize_height: i32, sigma_x, sigma_y: f64, border_type:i32) ---

	@(private, link_name = "cv_Canny")
	_canny :: proc(src, dst: ^Mat, threshold1, threshold2: f64, aperture_size: i32, l2gradient: bool) ---

	@(private, link_name = "cv_Sobel")
	_sobel :: proc(src, dst: ^Mat, ddepth, dx, dy: i32, ksize: i32, scale, delta: f64, border_type: i32) ---

	@(link_name = "cv_convertScaleAbs")
	convert_scale_abs :: proc(src, dst: ^Mat, alpha: f64 = 1, beta: f64 = 0) ---

	@(link_name = "cv_resize")
	resize :: proc(src, dst: ^Mat, width, height: i32) ---

	@(link_name = "cv_rotate")
	rotate :: proc(src, dst: ^Mat, rotate_code: RotateCode) ---

	@(link_name = "cv_flip")
	flip :: proc(src, dst: ^Mat, flip_code: FlipCode) ---

	@(link_name = "cv_convertTo")
	convert_to :: proc(src, dst: ^Mat, rtype: i32, alpha: f64 = 1, beta: f64 = 0) ---

	@(link_name = "cv_hconcat")
	hconcat :: proc(a, b, dst: ^Mat) ---

	@(link_name = "cv_cvtColor")
	cvt_color :: proc(src, dst: ^Mat, code: ColorConversion) ---

	@(link_name = "cv_channels")
	channels :: proc(mat: ^Mat) -> i32 ---

	@(link_name = "cv_imwrite")
	imwrite :: proc(filename: cstring, image: ^Mat) -> i32 ---
}

// Clean overload groups
init    :: proc{mat_init, video_capture_init, video_capture_init_from_file, video_writer_init, video_writer_init_with_params}
destroy :: proc{mat_destroy, video_capture_destroy, video_writer_destroy}
open    :: proc{video_capture_open, video_capture_open_file, video_writer_open}
release :: proc{video_capture_release, video_writer_release}
read    :: proc{video_capture_read}
get     :: proc{video_capture_get}
set     :: proc{video_capture_set}
empty   :: proc{mat_empty}

gaussian_blur :: proc(src, dst: ^Mat, ksize: [2]i32, sigma: [2]f64, border_type:=BorderType.REFLECT_101) {
	_gaussian_blur(src, dst, ksize[0], ksize[1], sigma[0], sigma[1], cast(i32)border_type)
}

canny :: proc(src, dst: ^Mat, thresholds: [2]f64, aperture_size: i32 = 3, l2gradient: bool = false) {
	_canny(src, dst, thresholds[0], thresholds[1], aperture_size, l2gradient)
}

sobel :: proc(src, dst: ^Mat, ddepth: DepthType, dx, dy: i32, ksize: i32 = 3, scale: f64 = 1, delta: f64 = 0, border_type:=BorderType.REFLECT_101) {
	_sobel(src, dst, cast(i32)ddepth, dx, dy, ksize, scale, delta, cast(i32)border_type)
}
