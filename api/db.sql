use `Diploma`;

create table `users` (
    `id` int auto_increment primary key,
    `name` varchar(64) not null unique,
    `password_hash` varchar(255) not null
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
(1, 'C++', 'Компилируемый язык для системного и прикладного программирования.', 'https://isocpp.org/assets/images/cpp_logo.png'),
(2, 'Python', 'Универсальный язык с простым синтаксисом для старта и автоматизации.', 'https://www.python.org/static/community_logos/python-logo-master-v3-TM.png');

create table `themes` (
    `id` int auto_increment primary key,
    `lang_id` int not null,
    `topic` varchar(255) not null,
    `theory` text not null,
    foreign key (`lang_id`) references `languages`(`id`) on delete cascade
);
insert into `themes` (`id`, `lang_id`, `topic`, `theory`) values
(1, 1, 'Основы синтаксиса и переменные', '<h2>Переменные и типы данных в C++</h2><p>Язык C++ является строго типизированным языком программирования. Это означает,что каждая переменная имеет определённый тип данных, который задаёт,какие значения она может хранить и сколько памяти занимает.</p><h3>Что такое переменная</h3><p>Переменная — это именованная область памяти, в которой хранится значение.Перед использованием переменную необходимо объявить.<br></p><pre>int age = 18;<br>double price = 10.5;<br>char letter = "A";</pre><p><br>Здесь:</p><ul><li><b>int</b> — целое число</li><li><b>double</b> — число с плавающей точкой</li><li><b>char</b> — один символ</li></ul><h3>Основные типы данных</h3><ul><li><b>int</b> — целые числа</li><li><b>float</b>, <b>double</b> — дробные числа</li><li><b>char</b> — символ</li><li><b>bool</b> — логический тип (true/false)</li><li><b>std::string</b> — строка</li></ul><h3>Ввод и вывод</h3><p>Для работы с консолью используется библиотека iostream.<br></p><pre>#include &lt;iostream&gt;<br>using namespace std;<br>int main() {<br>    cout &lt;&lt; "Hello!";<br>    return 0;<br>}</pre><p><br>Оператор <b>cout</b> выводит данные в консоль,а <b>cin</b> позволяет считывать данные от пользователя.</p><pre>int x;<br>cin &gt;&gt; x;</pre><h3>Инициализация переменных</h3><p>Переменные желательно инициализировать сразу при создании,чтобы избежать неопределённого поведения программы.</p><pre>int number = 0;</pre><p>Это хорошая практика программирования.</p>'),
(2, 1, 'Условия и циклы', ''),
(3, 1, 'Функции и массивы', '');

create table `tasks` (
    `id` int auto_increment primary key,
    `theme_id` int not null,
    `task` text not null,
    foreign key (`theme_id`) references `themes`(`id`) on delete cascade
);
insert into `tasks` (`id`, `theme_id`, `task`) values
(1, 1, '<b>Задание</b><br>Напиши простую программу, которая:<ol><li>Запрашивает у пользователя два числа.</li><li>Выводит их сумму.</li><br><p>Цель: научиться создавать переменные, использовать типы данных и базовый ввод/вывод.</p>');

create table `task_tests` (
    `id` int auto_increment primary key,
    `task_id` int not null,
    `input` text not null,
    `output` text not null,
    foreign key (`task_id`) references `tasks`(`id`) on delete cascade
);
insert into `task_tests` (`id`, `task_id`, `input`, `output`) values
(1, 1, '2 3\n', '5\n'),
(2, 1, '10 -5\n', '5\n');