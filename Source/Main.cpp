#include <SpApplication.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    sp::SpApplication app(argc, argv, "Color Rain");

    return app.exec();
}
