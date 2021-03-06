#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT

    public:
        static Settings& instance();
        ~Settings();

        /// @brief Устанавливет значение переменной в настройках
        /// @param name название переменной
        /// @param value устанавливаемое значение
        Q_INVOKABLE void set (const QString &key, const QVariant &value);

        /// @brief Возвращает значение переменной из настроек
        /// @param name название
        /// @param defaultValue значение по умолчанию, возвращаемое, если переменной нет в настройках
        Q_INVOKABLE QVariant get (const QString &key, const QVariant &defaultValue = QVariant()) const;

    protected:
        explicit Settings (const QString &applicationName, QObject *parent = 0);

    protected:
        QSettings _settings;
};

#endif // SETTINGS_H
