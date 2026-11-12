#include <opencv2/opencv.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>

#include <new>

extern "C" {

// --- Mat ---
void cv_Mat_init(cv::Mat* ptr) {
    new (ptr) cv::Mat();
}

void cv_Mat_destroy(cv::Mat* ptr) {
    if (ptr) ptr->~Mat();
}

bool cv_Mat_empty(cv::Mat* mat) {
    return mat ? mat->empty() : true;
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
    return (cap && image) ? cap->read(*image) : false;
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
    if (writer && image) writer->write(*image);
}

// --- HighGUI ---
void cv_namedWindow(const char* winname, int flags) {
    cv::namedWindow(winname, flags);
}

void cv_imshow(const char* winname, cv::Mat* mat) {
    if (mat) cv::imshow(winname, *mat);
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
    cv::GaussianBlur(*src, *dst, cv::Size(ksize_width, ksize_height), sigmaX, sigmaY, borderType);
}

void cv_Canny(cv::Mat* src, cv::Mat* dst, double threshold1, double threshold2, int apertureSize, bool L2gradient) {
    cv::Canny(*src, *dst, threshold1, threshold2, apertureSize, L2gradient);
}

void cv_Sobel(cv::Mat* src, cv::Mat* dst, int ddepth, int dx, int dy, int ksize, double scale, double delta, int borderType) {
    cv::Sobel(*src, *dst, ddepth, dx, dy, ksize, scale, delta, borderType);
}

void cv_convertScaleAbs(cv::Mat* src, cv::Mat* dst, double alpha, double beta) {
    cv::convertScaleAbs(*src, *dst, alpha, beta);
}

void cv_resize(cv::Mat* src, cv::Mat* dst, int width, int height) {
    cv::resize(*src, *dst, cv::Size(width, height));
}

void cv_rotate(cv::Mat* src, cv::Mat* dst, int rotateCode) {
    cv::rotate(*src, *dst, rotateCode);
}

void cv_flip(cv::Mat* src, cv::Mat* dst, int flipCode) {
    cv::flip(*src, *dst, flipCode);
}

void cv_convertTo(cv::Mat* src, cv::Mat* dst, int rtype, double alpha, double beta) {
    src->convertTo(*dst, rtype, alpha, beta);
}

void cv_hconcat(cv::Mat* a, cv::Mat* b, cv::Mat* dst) {
    cv::hconcat(*a, *b, *dst);
}

void cv_cvtColor(cv::Mat* src, cv::Mat* dst, int code) {
    cv::cvtColor(*src, *dst, code);
}

int cv_channels(cv::Mat* mat) {
    return mat ? mat->channels() : 0;
}

int cv_imwrite(const char* filename, cv::Mat* image) {
    return (image && cv::imwrite(filename, *image)) ? 1 : 0;
}

}
