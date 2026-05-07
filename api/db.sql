use `Diploma`;

create table `users` (
    `id` int auto_increment primary key,
    `name` varchar(64) not null unique,
    `password_hash` varchar(255) not null,
    `recovery_hash` varchar(255) null,
    `role` enum('student', 'teacher') not null default 'student'
);

create table `sessions` (
    `bearer_token` binary(15) primary key,
    `user_id` int not null,
    `created_at` datetime default current_timestamp,
    foreign key (`user_id`) references `users`(`id`) on delete cascade
);

create table `languages` (
    `id` int auto_increment primary key,
    `name` varchar(64) not null,
    `short_description` varchar(255) null,
    `photo_url` varchar(512) null
);
insert into `languages` (`id`, `name`, `short_description`, `photo_url`) values
(1, 'C++', 'Компилируемый язык для системного и прикладного программирования.', 'https://app.bogaledev.ru/images/cpp-logo.png'),
(2, 'Python', 'Универсальный язык с простым синтаксисом для старта и автоматизации.', 'https://app.bogaledev.ru/images/python-logo.png'),
(3, 'C#', 'Язык платформы .NET для прикладной разработки.', 'https://app.bogaledev.ru/images/csharp-logo.png'),
(4, 'Go', 'Компилируемый язык для сервисов и инфраструктуры.', 'https://app.bogaledev.ru/images/go-logo.png');

create table `themes` (
    `id` int auto_increment primary key,
    `lang_id` int not null,
    `topic` varchar(255) not null,
    `theory` text not null,
    foreign key (`lang_id`) references `languages`(`id`) on delete cascade
);
insert into `themes` (`id`, `lang_id`, `topic`, `theory`) values
(1, 1, 'Основы синтаксиса и переменные', '<h2>Переменные и типы данных в C++</h2><p>C++ строго типизирован; каждый объект имеет тип, определяющий допустимые значения и объём памяти.</p><h3>Переменная</h3><p>Переменная — именованная область памяти со значением. Перед использованием её объявляют.</p><pre>int age = 18;<br>double price = 10.5;<br>char letter = ''A'';</pre><ul><li><b>int</b> — целое число</li><li><b>double</b> — вещественное</li><li><b>char</b> — один символ</li></ul><h3>Вывод во взаимосвязи с вводом</h3><p>Библиотека iostream задаёт потоки <b>cin</b> и <b>cout</b>.</p><pre>#include &lt;iostream&gt;<br>using namespace std;<br>int main() {<br>    cout &lt;&lt; \"Hello\" &lt;&lt; endl;<br>    return 0;<br>}</pre><p>Инициализацию при объявлении предпочтительнее отложенному присваиванию: так меньше риска неинициализированных значений.</p>'),

(2, 1, 'Условия и циклы', '<h2>Управление потоком в C++</h2><p>Операторы <b>if</b>, <b>else</b>, <b>switch</b> позволяют ветвить логику. Циклы <b>while</b>, <b>do-while</b> и <b>for</b> выполняют повторяющиеся действия.</p><pre>if (x &gt; 0) { ++x; }<br>for (int i = 0; i &lt; n; ++i) { /* тело */ }</pre><h3>Выбор конструкции</h3><ul><li>Известное число итераций — чаще <b>for</b>.</li><li>Условие выхода заранее неизвестно — <b>while</b>.</li><li>Проверка после первого прохода — <b>do-while</b>.</li></ul><p>Избегайте бесконечных циклов без явного условия остановки; для подсчёта суммы или произведения инициализируйте накопитель до цикла.</p>'),

(3, 1, 'Функции и массивы', '<h2>Функции</h2><p>Функция инкапсулирует действие: сигнатура задаёт имя, параметры и тип результата. Тело выполняется при вызове.</p><pre>int add(int a, int b) { return a + b; }</pre><h3>Массивы и std::vector</h3><p>Статический массив фиксированного размера удобен на стеке; <b>std::vector&lt;int&gt;</b> динамически растёт и типичнее для задач переменной длины.</p><pre>vector&lt;int&gt; v(n);<br>for (int i = 0; i &lt; n; ++i) cin &gt;&gt; v[i];</pre><p>Передача больших объектов по константной ссылке снижает копирование: <code>void f(const vector&lt;int&gt;&amp; xs)</code>.</p>'),

(4, 3, 'Синтаксис и типы C#', '<h2>Типизация на платформе .NET</h2><p>В C# есть типы-значения структур и типы-ссылки классов. Компилятор выводит тип у <code>var</code> там, где это читаемо.</p><pre>int x = 42;<br>string s = \"demo\";<br>double y = 3.14;</pre><h3>Nullable и строки</h3><p>Для ссылочных типов отсутствие значения выражается <code>null</code>. Для значимых типов используют <code>int?</code> и т.п.</p><p>Строка в C# неизменяема; для сборки текста эффективнее <code>StringBuilder</code>, чем многократная конкатенация в цикле.</p>'),

(5, 3, 'Классы и интерфейсы', '<h2>ООП в C#</h2><p><b>Класс</b> объединяет поля, методы, конструкторы. <b>Интерфейс</b> задаёт контракт без реализации; класс может реализовать несколько интерфейсов.</p><pre>public interface IDrawable { void Draw(); }<br>public class Circle : IDrawable {<br>  public void Draw() { /* ... */ }<br>}</pre><h3>Доступ и инкапсуляция</h3><p>Модификаторы <code>public</code>, <code>private</code>, <code>protected</code> ограничивают видимость. Свойства (<code>get</code>/<code>set</code>) дают контролируемый доступ к данным вместо открытых полей.</p>'),

(6, 4, 'Базовые конструкции Go', '<h2>Переменные и поток управления</h2><p>Объявление <code>var x int = 1</code> или краткая форма <code>x := 1</code> внутри функций. Нет неявных преобразований — явность снижает ошибки.</p><pre>if v := compute(); v &lt; 0 { return v }</pre><p>Цикл в Go — единственная конструкция <code>for</code>; отсутствуют <code>while</code> и <code>do-while</code> как отдельные ключевые слова.</p><h3>Множественный возврат</h3><p>Функции часто возвращают значение и <code>error</code>; вызывающий код проверяет ошибку — идиоматичный стиль Go.</p>'),

(7, 4, 'Функции и структуры', '<h2>Функции и пользовательские типы</h2><p>Функция объявляется с ключевым словом <code>func</code>. Метод — функция с получателем (значение или указатель на структуру).</p><pre>type Point struct { X, Y float64 }<br>func (p Point) Len() float64 { return math.Sqrt(p.X*p.X + p.Y*p.Y) }</pre><h3>Указатели</h3><p>Указатель <code>*T</code> позволяет изменять исходную структуру и избегать копирования больших значений. Получатель-указатель нужен, если метод меняет состояние.</p>'),

(8, 2, 'Основы Python: переменные и типы', '<h2>Динамическая типизация</h2><p>В Python имя ссылается на объект; тип определяется значением. Базовые типы: <code>int</code>, <code>float</code>, <code>str</code>, <code>bool</code>.</p><pre>x = 10<br>name = \"student\"<br>pi = 3.14</pre><h3>Ввод-вывод</h3><p><code>print()</code> выводит в консоль; <code>input()</code> читает строку. Для чисел используют <code>int()</code> или <code>float()</code>.</p><p>Среда проверки заданий в приложении компилирует решение как C++; сопоставьте идеи Python с аналогами в C++ (типы, форматирование вывода).</p>'),

(9, 2, 'Условия, циклы и логика', '<h2>if, while, for</h2><p>Отступы задают блоки. <code>for x in range(n):</code> итерирует от 0 до n-1.</p><pre>for i in range(5):<br>    print(i)</pre><h3>Истинность</h3><p>Пустые коллекции и <code>None</code> считаются ложью; для сравнения ссылок на объекты используют <code>is</code>, для значений — <code>==</code>.</p><p>При переносе алгоритма на C++ следите за границами массива и типом индекса.</p>'),

(10, 2, 'Функции и коллекции', '<h2>Функции и списки</h2><p>Функции объявляют через <code>def</code>; могут возвращать несколько значений как кортеж. Список <code>[]</code> изменяем, кортеж <code>()</code> — нет.</p><pre>def mean(nums):<br>    return sum(nums) / len(nums)</pre><h3>List comprehension</h3><p>Краткая форма построения списков: <code>[x*x for x in range(10) if x % 2 == 0]</code>.</p><p>В C++ аналогом динамического списка часто служит <code>std::vector</code> и циклы или алгоритмы из <code>&lt;algorithm&gt;</code>.</p>'),

(11, 3, 'Коллекции и обработка ошибок', '<h2>System.Collections</h2><p><code>List&lt;T&gt;</code>, <code>Dictionary&lt;TKey,TValue&gt;</code> и <code>HashSet&lt;T&gt;</code> — основные структуры BCL. LINQ позволяет декларативно фильтровать и проецировать данные.</p><pre>var evens = items.Where(x =&gt; x % 2 == 0);</pre><h3>Исключения</h3><p><code>try / catch / finally</code> обрабатывают сбои. Не используйте пустые <code>catch</code>; логируйте или перевыбрасывайте осмысленные исключения.</p>'),

(12, 4, 'Интерфейсы и конкурентность', '<h2>Интерфейсы в Go</h2><p>Интерфейс удовлетворяется неявно: любой тип с нужными методами реализует интерфейс. Это снижает связность пакетов.</p><h2>Goroutine и канал</h2><p><code>go f()</code> запускает <code>f</code> конкурентно. Каналы <code>chan T</code> передают значения между горутинами с синхронизацией.</p><pre>ch := make(chan int)<br>go func() { ch &lt;- 42 }()<br>v := &lt;-ch</pre><p>Для задач платформы алгоритм может быть реализован в одном потоке на C++; идеи из этой темы применимы к проектированию ясной декомпозиции функций.</p>');

create table `tasks` (
    `id` int auto_increment primary key,
    `theme_id` int not null,
    `task` text not null,
    foreign key (`theme_id`) references `themes`(`id`) on delete cascade
);
insert into `tasks` (`id`, `theme_id`, `task`) values
(1, 1, '<b>Задание</b><br>Напишите программу на <b>C++</b>:<ol><li>Считайте два целых числа.</li><li>Выведите их сумму и перевод строки.</li></ol><p>Цель: переменные, ввод/вывод.</p>'),
(2, 2, '<b>Задание</b><br>На <b>C++</b>: по данному целому <code>n</code> (0 ≤ n ≤ 12) вычислите <code>n!</code> и выведите результат с переводом строки. Помните, что <code>0! = 1</code>.</p>'),
(3, 3, '<b>Задание</b><br>На <b>C++</b>: в первой строке целое <code>n</code> (1 ≤ n ≤ 100), далее <code>n</code> целых чисел. Выведите сумму всех чисел и перевод строки.</p>'),
(4, 4, '<b>Задание</b><br>На <b>C++</b>: считайте одно целое число и выведите его квадрат (целое) с переводом строки.</p>'),
(5, 5, '<b>Задание</b><br>На <b>C++</b>: считайте одно целое <code>a</code> и выведите <code>3*a</code> с переводом строки.</p>'),
(6, 6, '<b>Задание</b><br>На <b>C++</b>: считайте два целых числа <code>x</code> и <code>y</code> и выведите модуль их разности (неотрицательное значение |x-y|) как целое с переводом строки.</p>'),
(7, 7, '<b>Задание</b><br>На <b>C++</b>: считайте два натуральных числа <code>a</code> и <code>b</code> и выведите их наибольший общий делитель с переводом строки.</p>'),
(8, 8, '<b>Задание</b><br>На <b>C++</b> (материалы темы — Python): считайте два неотрицательных целых a и b (b &gt; 0) и выведите результат целочисленного деления a/b без остатка с переводом строки.</p>'),
(9, 9, '<b>Задание</b><br>На <b>C++</b>: в первой строке целое <code>n</code> (1 ≤ n ≤ 45). Выведите <code>n</code>-й элемент последовательности Фибоначчи с нуля: F<sub>0</sub>=0, F<sub>1</sub>=1, каждое следующее — сумма двух предыдущих. Число выведите с переводом строки.</p>'),
(10, 10, '<b>Задание</b><br>На <b>C++</b>: первая строка — целое <code>n</code> (1 ≤ n ≤ 100). Далее <code>n</code> целых. Выведите среднее значение как целую часть (целое деление суммы на n) с переводом строки.</p>'),
(11, 11, '<b>Задание</b><br>На <b>C++</b>: одна строка из строчных латинских букв (без пробелов). Подсчитайте гласные из набора <code>a, e, i, o, u</code> и выведите количество с переводом строки.</p>'),
(12, 12, '<b>Задание</b><br>На <b>C++</b>: одна строка из печатных ASCII-символов без пробела в конце. Выведите сумму кодов всех символов строки (как в Go <code>byte</code>) с переводом строки.</p>');

create table `task_tests` (
    `id` int auto_increment primary key,
    `task_id` int not null,
    `input` text not null,
    `output` text not null,
    foreign key (`task_id`) references `tasks`(`id`) on delete cascade
);
insert into `task_tests` (`id`, `task_id`, `input`, `output`) values
(1, 1, '2 3\n', '5\n'),
(2, 1, '10 -5\n', '5\n'),
(3, 2, '5\n', '120\n'),
(4, 2, '0\n', '1\n'),
(5, 3, '3\n10 20 30\n', '60\n'),
(6, 3, '4\n7 8 10 100\n', '125\n'),
(7, 4, '12\n', '144\n'),
(8, 4, '15\n', '225\n'),
(9, 5, '9\n', '27\n'),
(10, 5, '42\n', '126\n'),
(11, 6, '48 73\n', '25\n'),
(12, 6, '10 50\n', '40\n'),
(13, 7, '48 36\n', '12\n'),
(14, 7, '17 13\n', '1\n'),
(15, 8, '47 10\n', '4\n'),
(16, 8, '100 7\n', '14\n'),
(17, 9, '7\n', '13\n'),
(18, 9, '10\n', '55\n'),
(19, 10, '4\n10 20 30 40\n', '25\n'),
(20, 10, '3\n7 8 10\n', '8\n'),
(21, 11, 'hello\n', '2\n'),
(22, 11, 'xyz\n', '0\n'),
(23, 12, 'ABC\n', '198\n'),
(24, 12, 'a\n', '97\n');


create table `user_theme_progress` (
    `user_id` int not null,
    `theme_id` int not null,
    `progress_percent` tinyint unsigned not null default 0,
    `updated_at` timestamp not null default current_timestamp on update current_timestamp,
    primary key (`user_id`, `theme_id`),
    foreign key (`user_id`) references `users`(`id`) on delete cascade,
    foreign key (`theme_id`) references `themes`(`id`) on delete cascade
);

create table `user_task_solved` (
    `user_id` int not null,
    `task_id` int not null,
    `solved_at` timestamp not null default current_timestamp,
    primary key (`user_id`, `task_id`),
    foreign key (`user_id`) references `users`(`id`) on delete cascade,
    foreign key (`task_id`) references `tasks`(`id`) on delete cascade
);
