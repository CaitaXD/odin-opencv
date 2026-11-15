#include <cstdint>
#include <new>
#include <opencv.hpp>
#include <videoio.hpp>
#include <highgui.hpp>

static inline void fixup_mat2d(cv::Mat* m) {
    if (!m) return;
    if (m->dims <= 2) {
        m->size.p = &m->rows;
        m->step.p = m->step.buf;
    }
}

extern "C" {

// --- Mat ---
// The header size exported as a symbol: this is what the Odin mirror pads around,
// so its own half of the struct starts at an offset that comes from C++ instead of
// being asserted (or guessed) on the Odin side. The Odin fields past it belong to
// Odin; the placement new below only ever writes the sizeof(cv::Mat) header bytes.
extern "C" const std::int32_t cv_mat_sizeof = static_cast<std::int32_t>(sizeof(cv::Mat));

void cv_Mat_init(cv::Mat* ptr, std::int32_t rows, std::int32_t cols, std::int32_t type) {
    new (ptr) cv::Mat(rows, cols, type);
}

void cv_Mat_init_from_data(cv::Mat* ptr, std::int32_t rows, std::int32_t cols, std::int32_t type, void* data) {
    new (ptr) cv::Mat(rows, cols, type, data);
}

void cv_Mat_destroy(cv::Mat* ptr) {
    if (ptr) {
        fixup_mat2d(ptr);
        ptr->~Mat();
    }
}

bool cv_Mat_empty(cv::Mat* mat) {
    if (!mat) return true;
    fixup_mat2d(mat);
    return mat->empty();
}

// --- VideoCapture ---
void cv_VideoCapture_init(cv::VideoCapture* ptr, int index, int api_preference) {
    new (ptr) cv::VideoCapture(index, api_preference);
}

void cv_VideoCapture_init_from_file(cv::VideoCapture* ptr, const char* filename, int api_preference) {
    new (ptr) cv::VideoCapture(filename, api_preference);
}

void cv_VideoCapture_destroy(cv::VideoCapture* ptr) {
    if (ptr) {
        ptr->release();
        ptr->~VideoCapture();
    }
}

bool cv_VideoCapture_open(cv::VideoCapture* cap, int index, int api_preference) {
    return cap ? cap->open(index, api_preference) : false;
}

bool cv_VideoCapture_open_file(cv::VideoCapture* cap, const char* filename, int api_preference) {
    return cap ? cap->open(filename, api_preference) : false;
}

void cv_VideoCapture_release(cv::VideoCapture* cap) {
    if (cap) cap->release();
}

bool cv_VideoCapture_isOpened(cv::VideoCapture* cap) {
    return cap ? cap->isOpened() : false;
}

bool cv_VideoCapture_read(cv::VideoCapture* cap, cv::Mat* image) {
    if (!cap || !image) return false;
    fixup_mat2d(image);
    return cap->read(*image);
}

bool cv_VideoCapture_set(cv::VideoCapture* cap, int propId, double value) {
    return cap ? cap->set(propId, value) : false;
}

double cv_VideoCapture_get(cv::VideoCapture* cap, int propId) {
    return cap ? cap->get(propId) : 0.0;
}

// --- VideoWriter ---
void cv_VideoWriter_init(cv::VideoWriter* ptr) {
    new (ptr) cv::VideoWriter();
}

void cv_VideoWriter_init_with_params(cv::VideoWriter* ptr, const char* filename, int fourcc, double fps, int width, int height, bool isColor) {
    new (ptr) cv::VideoWriter(filename, fourcc, fps, cv::Size(width, height), isColor);
}

void cv_VideoWriter_destroy(cv::VideoWriter* ptr) {
    if (ptr) {
        ptr->release();
        ptr->~VideoWriter();
    }
}

bool cv_VideoWriter_open(cv::VideoWriter* writer, const char* filename, int fourcc, double fps, int width, int height, bool isColor) {
    return writer ? writer->open(filename, fourcc, fps, cv::Size(width, height), isColor) : false;
}

void cv_VideoWriter_release(cv::VideoWriter* writer) {
    if (writer) writer->release();
}

bool cv_VideoWriter_isOpened(cv::VideoWriter* writer) {
    return writer ? writer->isOpened() : false;
}

void cv_VideoWriter_write(cv::VideoWriter* writer, cv::Mat* image) {
    if (writer && image) {
        fixup_mat2d(image);
        writer->write(*image);
    }
}

// --- HighGUI ---
void cv_namedWindow(const char* winname, int flags) {
    cv::namedWindow(winname, flags);
}

void cv_imshow(const char* winname, cv::Mat* mat) {
    if (mat) {
        fixup_mat2d(mat);
        cv::imshow(winname, *mat);
    }
}

int cv_waitKey(int delay) {
    return cv::waitKey(delay);
}

void cv_destroyAllWindows() {
    cv::destroyAllWindows();
}

void cv_destroyWindow(const char* winname) {
    cv::destroyWindow(winname);
}

void cv_resizeWindow(const char* winname, int width, int height) {
    cv::resizeWindow(winname, width, height);
}

int cv_createTrackbar(const char* trackbarname, const char* winname, int* value, int count) {
    return cv::createTrackbar(trackbarname, winname, value, count);
}

int cv_getTrackbarPos(const char* trackbarname, const char* winname) {
    return cv::getTrackbarPos(trackbarname, winname);
}

void cv_setTrackbarPos(const char* trackbarname, const char* winname, int pos) {
    cv::setTrackbarPos(trackbarname, winname, pos);
}

void cv_setTrackbarMax(const char* trackbarname, const char* winname, int maxval) {
    cv::setTrackbarMax(trackbarname, winname, maxval);
}

void cv_setTrackbarMin(const char* trackbarname, const char* winname, int minval) {
    cv::setTrackbarMin(trackbarname, winname, minval);
}

int cv_createButton(const char* bar_name, void (*on_change)(int state, void* userdata), void* userdata, int type, bool initial_button_state) {
    return cv::createButton(bar_name, on_change, userdata, type, initial_button_state);
}

// --- Image Processing ---
void cv_GaussianBlur(cv::Mat* src, cv::Mat* dst, int ksize_width, int ksize_height, double sigmaX, double sigmaY, int borderType) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::GaussianBlur(*src, *dst, cv::Size(ksize_width, ksize_height), sigmaX, sigmaY, borderType);
}

void cv_Canny(cv::Mat* src, cv::Mat* dst, double threshold1, double threshold2, int apertureSize, bool L2gradient) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::Canny(*src, *dst, threshold1, threshold2, apertureSize, L2gradient);
}

void cv_Sobel(cv::Mat* src, cv::Mat* dst, int ddepth, int dx, int dy, int ksize, double scale, double delta, int borderType) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::Sobel(*src, *dst, ddepth, dx, dy, ksize, scale, delta, borderType);
}

void cv_convertScaleAbs(cv::Mat* src, cv::Mat* dst, double alpha, double beta) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::convertScaleAbs(*src, *dst, alpha, beta);
}

void cv_resize(cv::Mat* src, cv::Mat* dst, int width, int height) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::resize(*src, *dst, cv::Size(width, height));
}

void cv_rotate(cv::Mat* src, cv::Mat* dst, int rotateCode) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::rotate(*src, *dst, rotateCode);
}

void cv_flip(cv::Mat* src, cv::Mat* dst, int flipCode) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::flip(*src, *dst, flipCode);
}

void cv_convertTo(cv::Mat* src, cv::Mat* dst, int rtype, double alpha, double beta) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    src->convertTo(*dst, rtype, alpha, beta);
}

void cv_hconcat(cv::Mat* a, cv::Mat* b, cv::Mat* dst) {
    fixup_mat2d(a);
    fixup_mat2d(b);
    fixup_mat2d(dst);
    cv::hconcat(*a, *b, *dst);
}

void cv_cvtColor(cv::Mat* src, cv::Mat* dst, int code) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::cvtColor(*src, *dst, code);
}

int cv_channels(cv::Mat* mat) {
    if (!mat) return 0;
    fixup_mat2d(mat);
    return mat->channels();
}

int cv_imwrite(const char* filename, cv::Mat* image) {
    if (!image) return 0;
    fixup_mat2d(image);
    return cv::imwrite(filename, *image) ? 1 : 0;
}

void cv_filter2D(cv::Mat* src, cv::Mat* dst, int ddepth, cv::Mat* kernel, int borderType) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    fixup_mat2d(kernel);
    cv::filter2D(*src, *dst, ddepth, *kernel, cv::Point(-1, -1), 0.0, borderType);
}

double cv_threshold(cv::Mat* src, cv::Mat* dst, double thresh, double maxval, int type) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    return cv::threshold(*src, *dst, thresh, maxval, type);
}

double cv_sum(cv::Mat* mat) {
    fixup_mat2d(mat);
    return cv::sum(*mat)[0];
}

void cv_bitwise_and(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::bitwise_and(*src1, *src2, *dst);
}

void cv_divide(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::divide(*src1, *src2, *dst);
}

void cv_add(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::add(*src1, *src2, *dst);
}

void cv_multiply(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::multiply(*src1, *src2, *dst);
}

void cv_magnitude(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::magnitude(*src1, *src2, *dst);
}

void cv_max(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::max(*src1, *src2, *dst);
}

void cv_merge(cv::Mat* src1, cv::Mat* src2, cv::Mat* dst) {
    fixup_mat2d(src1);
    fixup_mat2d(src2);
    fixup_mat2d(dst);
    cv::Mat planes[] = { *src1, *src2 };
    cv::merge(planes, 2, *dst);
}

void cv_setTo(cv::Mat* mat, double value, cv::Mat* mask) {
    fixup_mat2d(mat);
    fixup_mat2d(mask);
    if (mask && !mask->empty()) {
        mat->setTo(cv::Scalar(value), *mask);
    } else {
        mat->setTo(cv::Scalar(value));
    }
}

void cv_copyTo(cv::Mat* src, cv::Mat* dst, cv::Mat* mask) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    fixup_mat2d(mask);
    if (mask && !mask->empty()) {
        src->copyTo(*dst, *mask);
    } else {
        src->copyTo(*dst);
    }
}

void cv_copy_make_border(cv::Mat* src, cv::Mat* dst, int top, int bottom, int left, int right, int borderType) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::copyMakeBorder(*src, *dst, top, bottom, left, right, borderType);
}

void cv_gradient_x(cv::Mat* src, cv::Mat* dst) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::Sobel(*src, *dst, -1, 1, 0, 3, 1.0, 0.0, cv::BORDER_DEFAULT);
}

void cv_gradient_y(cv::Mat* src, cv::Mat* dst) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    cv::Sobel(*src, *dst, -1, 0, 1, 3, 1.0, 0.0, cv::BORDER_DEFAULT);
}

void cv_remap(cv::Mat* src, cv::Mat* dst, cv::Mat* map1, cv::Mat* map2, int interpolation, int borderMode) {
    fixup_mat2d(src);
    fixup_mat2d(dst);
    fixup_mat2d(map1);
    fixup_mat2d(map2);
    cv::remap(*src, *dst, *map1, *map2, interpolation, borderMode, cv::Scalar(0));
}

}
