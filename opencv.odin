package opencv

import "base:runtime"

// --- Core structs ---
Mat :: struct($T: typeid) #align(8) {
	flags:     i32,
	dims:      i32,
	rows:      i32,
	cols:      i32,
	data:      [^]T,
	datastart: [^]T,
	dataend:   [^]T,
	datalimit: [^]T,
	allocator: rawptr,
	u:         rawptr,
	size:      rawptr,
	step:      [3]uint,
}

VideoCapture :: struct #align(8) {
	_data: [48]u8,
}

VideoWriter :: struct #align(8) {
	_data: [40]u8,
}

#assert(size_of(Mat(u8)) == 96)
#assert(size_of(Mat(f32)) == 96)
#assert(size_of(VideoCapture) == 48)
#assert(size_of(VideoWriter) == 40)

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

// --- Threshold types ---
ThresholdType :: enum i32 {
	BINARY     = 0,
	BINARY_INV = 1,
	TRUNC      = 2,
	TOZERO     = 3,
	TOZERO_INV = 4,
}

THRESH_BINARY     :: ThresholdType.BINARY
THRESH_BINARY_INV :: ThresholdType.BINARY_INV

// --- Interpolation flags ---
InterpolationFlags :: enum i32 {
	NEAREST  = 0,
	LINEAR   = 1,
	CUBIC    = 2,
	AREA     = 3,
	LANCZOS4 = 4,
}

INTER_NEAREST :: InterpolationFlags.NEAREST
INTER_LINEAR  :: InterpolationFlags.LINEAR

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
	_mat_init :: proc(ptr: rawptr, rows: i32, cols: i32, type: i32) ---

	@(link_name = "cv_Mat_init_from_data")
	_mat_init_from_data :: proc(ptr: rawptr, rows: i32, cols: i32, type: i32, data: rawptr) ---

	@(link_name = "cv_Mat_destroy")
	_mat_destroy :: proc(ptr: rawptr) ---

	@(link_name = "cv_Mat_empty")
	_mat_empty :: proc(mat: rawptr) -> bool ---

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
	_video_capture_read :: proc(cap: ^VideoCapture, image: rawptr) -> bool ---

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
	_video_writer_write :: proc(writer: ^VideoWriter, image: rawptr) ---

	// HighGUI
	@(link_name = "cv_namedWindow")
	named_window :: proc(winname: cstring, flags: WindowFlags = .AUTOSIZE) ---

	@(link_name = "cv_imshow")
	_imshow :: proc(winname: cstring, mat: rawptr) ---

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
	@(link_name = "cv_GaussianBlur")
	_gaussian_blur :: proc(src, dst: rawptr, ksize_width, ksize_height: i32, sigma_x, sigma_y: f64, border_type: i32) ---

	@(link_name = "cv_Canny")
	_canny :: proc(src, dst: rawptr, threshold1, threshold2: f64, aperture_size: i32, l2gradient: bool) ---

	@(link_name = "cv_Sobel")
	_sobel :: proc(src, dst: rawptr, ddepth, dx, dy: i32, ksize: i32, scale, delta: f64, border_type: i32) ---

	@(link_name = "cv_convertScaleAbs")
	_convert_scale_abs :: proc(src, dst: rawptr, alpha: f64 = 1, beta: f64 = 0) ---

	@(link_name = "cv_resize")
	_resize :: proc(src, dst: rawptr, width, height: i32) ---

	@(link_name = "cv_rotate")
	_rotate :: proc(src, dst: rawptr, rotate_code: RotateCode) ---

	@(link_name = "cv_flip")
	_flip :: proc(src, dst: rawptr, flip_code: FlipCode) ---

	@(link_name = "cv_convertTo")
	_convert_to :: proc(src, dst: rawptr, rtype: i32, alpha: f64 = 1, beta: f64 = 0) ---

	@(link_name = "cv_hconcat")
	_hconcat :: proc(a, b, dst: rawptr) ---

	@(link_name = "cv_cvtColor")
	_cvt_color :: proc(src, dst: rawptr, code: ColorConversion) ---

	@(link_name = "cv_channels")
	_channels :: proc(mat: rawptr) -> i32 ---

	@(link_name = "cv_imwrite")
	_imwrite :: proc(filename: cstring, image: rawptr) -> i32 ---

	@(link_name = "cv_filter2D")
	_filter2D :: proc(src, dst: rawptr, ddepth: i32, kernel: rawptr, border_type: i32) ---

	@(link_name = "cv_threshold")
	_threshold :: proc(src, dst: rawptr, thresh, maxval: f64, type: i32) -> f64 ---

	@(link_name = "cv_bitwise_and")
	_bitwise_and :: proc(src1, src2, dst: rawptr) ---

	@(link_name = "cv_divide")
	_divide :: proc(src1, src2, dst: rawptr) ---

	@(link_name = "cv_add")
	_add :: proc(src1, src2, dst: rawptr) ---

	@(link_name = "cv_setTo")
	_set_to :: proc(mat: rawptr, value: f64, mask: rawptr) ---

	@(link_name = "cv_copyTo")
	_copy_to :: proc(src, dst, mask: rawptr) ---

	@(link_name = "cv_gradient_x")
	_gradient_x :: proc(src, dst: rawptr) ---

	@(link_name = "cv_gradient_y")
	_gradient_y :: proc(src, dst: rawptr) ---

	@(link_name = "cv_remap")
	_remap :: proc(src, dst, map1, map2: rawptr, interpolation, border_mode: i32) ---
}

// --- Procedural wrappers for Mat ---

mat_init :: proc(ptr: ^Mat($T), rows: i32 = 0, cols: i32 = 0, type: i32 = 0) {
	_mat_init(ptr, rows, cols, type)
}

mat_destroy :: proc(ptr: ^Mat($T)) {
	_mat_destroy(ptr)
}

mat_empty :: proc(mat: ^Mat($T)) -> bool {
	return _mat_empty(mat)
}

new_mat :: proc($T: typeid, rows, cols: int) -> (m: Mat(T)) {
	cv_type: i32
	when T == u8 {
		cv_type = 0 // CV_8U
	} else when T == i8 {
		cv_type = 1 // CV_8S
	} else when T == u16 {
		cv_type = 2 // CV_16U
	} else when T == i16 {
		cv_type = 3 // CV_16S
	} else when T == i32 {
		cv_type = 4 // CV_32S
	} else when T == f32 {
		cv_type = 5 // CV_32F
	} else when T == f64 {
		cv_type = 6 // CV_64F
	} else {
		#panic("Unsupported Mat element type")
	}
	_mat_init(&m, i32(rows), i32(cols), cv_type)
	return m
}

view_slice :: proc(data: []$T, rows, cols: int) -> (m: Mat(T)) {
	cv_type: i32
	when T == u8 {
		cv_type = 0
	} else when T == i8 {
		cv_type = 1
	} else when T == u16 {
		cv_type = 2
	} else when T == i16 {
		cv_type = 3
	} else when T == i32 {
		cv_type = 4
	} else when T == f32 {
		cv_type = 5
	} else when T == f64 {
		cv_type = 6
	} else {
		#panic("Unsupported Mat element type")
	}
	_mat_init_from_data(&m, i32(rows), i32(cols), cv_type, raw_data(data))
	return m
}

view_ptr :: proc(data: [^]$T, rows, cols: int) -> (m: Mat(T)) {
	cv_type: i32
	when T == u8 {
		cv_type = 0
	} else when T == i8 {
		cv_type = 1
	} else when T == u16 {
		cv_type = 2
	} else when T == i16 {
		cv_type = 3
	} else when T == i32 {
		cv_type = 4
	} else when T == f32 {
		cv_type = 5
	} else when T == f64 {
		cv_type = 6
	} else {
		#panic("Unsupported Mat element type")
	}
	_mat_init_from_data(&m, i32(rows), i32(cols), cv_type, rawptr(data))
	return m
}

view :: proc{view_slice, view_ptr}

pixels_ptr :: proc(m: ^Mat($T)) -> []T {
	if m == nil || m.data == nil do return nil
	return m.data[:int(m.rows * m.cols)]
}

pixels_val :: proc(m: Mat($T)) -> []T {
	if m.data == nil do return nil
	return m.data[:int(m.rows * m.cols)]
}

pixels :: proc{pixels_ptr, pixels_val}

filter_2d :: proc(src: ^Mat($TS), dst: ^Mat($TD), kernel: ^Mat($TK), ddepth: i32 = -1, border_type: BorderType = .CONSTANT) {
	_filter2D(src, dst, ddepth, kernel, i32(border_type))
}

threshold_mask :: proc(src, dst: ^Mat($T), thresh: f64, maxval: f64, type: ThresholdType) {
	_threshold(src, dst, thresh, maxval, i32(type))
}

and_masks :: proc(src1, src2, dst: ^Mat($T)) {
	_bitwise_and(src1, src2, dst)
}

divide_images :: proc(src1, src2, dst: ^Mat($T)) {
	_divide(src1, src2, dst)
}

add_images :: proc(src1, src2, dst: ^Mat($T)) {
	_add(src1, src2, dst)
}

set_to :: proc(mat: ^Mat($T), value: f64, mask: ^Mat($TM) = nil) {
	_set_to(mat, value, mask)
}

copy_to :: proc(src, dst: ^Mat($TS), mask: ^Mat($TM) = nil) {
	_copy_to(src, dst, mask)
}

gradient_x :: proc(src, dst: ^Mat($T)) {
	_gradient_x(src, dst)
}

gradient_y :: proc(src, dst: ^Mat($T)) {
	_gradient_y(src, dst)
}

resample :: proc(src: ^Mat($TS), dst: ^Mat($TD), map1: ^Mat($TM1), map2: ^Mat($TM2), interpolation: InterpolationFlags = .NEAREST, border_mode: BorderType = .CONSTANT) {
	_remap(src, dst, map1, map2, i32(interpolation), i32(border_mode))
}

imshow :: proc(winname: cstring, mat: ^Mat($T)) {
	_imshow(winname, mat)
}

video_capture_read :: proc(cap: ^VideoCapture, image: ^Mat($T)) -> bool {
	return _video_capture_read(cap, image)
}

video_writer_write :: proc(writer: ^VideoWriter, image: ^Mat($T)) {
	_video_writer_write(writer, image)
}

gaussian_blur :: proc(src, dst: ^Mat($T), ksize: [2]i32, sigma: [2]f64, border_type := BorderType.REFLECT_101) {
	_gaussian_blur(src, dst, ksize[0], ksize[1], sigma[0], sigma[1], cast(i32)border_type)
}

canny :: proc(src, dst: ^Mat($T), thresholds: [2]f64, aperture_size: i32 = 3, l2gradient: bool = false) {
	_canny(src, dst, thresholds[0], thresholds[1], aperture_size, l2gradient)
}

sobel :: proc(src, dst: ^Mat($T), ddepth: DepthType, dx, dy: i32, ksize: i32 = 3, scale: f64 = 1, delta: f64 = 0, border_type := BorderType.REFLECT_101) {
	_sobel(src, dst, cast(i32)ddepth, dx, dy, ksize, scale, delta, cast(i32)border_type)
}

convert_scale_abs :: proc(src, dst: ^Mat($T), alpha: f64 = 1, beta: f64 = 0) {
	_convert_scale_abs(src, dst, alpha, beta)
}

resize :: proc(src, dst: ^Mat($T), width, height: i32) {
	_resize(src, dst, width, height)
}

rotate :: proc(src, dst: ^Mat($T), rotate_code: RotateCode) {
	_rotate(src, dst, rotate_code)
}

flip :: proc(src, dst: ^Mat($T), flip_code: FlipCode) {
	_flip(src, dst, flip_code)
}

convert_to :: proc(src, dst: ^Mat($T), rtype: i32, alpha: f64 = 1, beta: f64 = 0) {
	_convert_to(src, dst, rtype, alpha, beta)
}

hconcat :: proc(a, b, dst: ^Mat($T)) {
	_hconcat(a, b, dst)
}

cvt_color :: proc(src, dst: ^Mat($T), code: ColorConversion) {
	_cvt_color(src, dst, code)
}

channels :: proc(mat: ^Mat($T)) -> i32 {
	return _channels(mat)
}

imwrite :: proc(filename: cstring, image: ^Mat($T)) -> i32 {
	return _imwrite(filename, image)
}

// Clean overload groups
init    :: proc{mat_init, video_capture_init, video_capture_init_from_file, video_writer_init, video_writer_init_with_params}
destroy :: proc{mat_destroy, video_capture_destroy, video_writer_destroy}
open    :: proc{video_capture_open, video_capture_open_file, video_writer_open}
release :: proc{video_capture_release, video_writer_release}
read    :: proc{video_capture_read}
write   :: proc{video_writer_write}
get     :: proc{video_capture_get}
set     :: proc{video_capture_set}
empty   :: proc{mat_empty}
