import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Diploma 1.0

Column {
    spacing: 10
    padding: 20
    required property int theme_id
    property var theoryContents: ['<h2>Переменные и типы данных в C++</h2><p>Язык C++ является строго типизированным языком программирования. Это означает,что каждая переменная имеет определённый тип данных, который задаёт,какие значения она может хранить и сколько памяти занимает.</p><h3>Что такое переменная</h3><p>Переменная — это именованная область памяти, в которой хранится значение.Перед использованием переменную необходимо объявить.<br></p><pre>int age = 18;<br>double price = 10.5;<br>char letter = "A";</pre><p><br>Здесь:</p><ul><li><b>int</b> — целое число</li><li><b>double</b> — число с плавающей точкой</li><li><b>char</b> — один символ</li></ul><h3>Основные типы данных</h3><ul><li><b>int</b> — целые числа</li><li><b>float</b>, <b>double</b> — дробные числа</li><li><b>char</b> — символ</li><li><b>bool</b> — логический тип (true/false)</li><li><b>std::string</b> — строка</li></ul><h3>Ввод и вывод</h3><p>Для работы с консолью используется библиотека iostream.<br></p><pre>#include &lt;iostream&gt;<br>using namespace std;<br>int main() {<br>    cout &lt;&lt; "Hello!";<br>    return 0;<br>}</pre><p><br>Оператор <b>cout</b> выводит данные в консоль,а <b>cin</b> позволяет считывать данные от пользователя.</p><pre>int x;<br>cin &gt;&gt; x;</pre><h3>Инициализация переменных</h3><p>Переменные желательно инициализировать сразу при создании,чтобы избежать неопределённого поведения программы.</p><pre>int number = 0;</pre><p>Это хорошая практика программирования.</p>']
    signal taskDemanded(int theme_id)

    ScrollView {
        id: scrollView
        width: parent.width * 0.8
        height: parent.height * 0.7

        ScrollBar.horizontal.interactive: false

        Text {
            width: scrollView.width
            wrapMode: Text.WordWrap
            text: theoryContents[theme_id - 1]
            font.pixelSize: 22
        }
    }

    Button {
        text: "Перейти к заданию"
        onClicked: taskDemanded(theme_id)
    }
}
