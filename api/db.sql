create table users (
    id int auto_increment primary key,
    name varchar(64) not null unique,
    password_hash varchar(255) not null
);
create table sessions (
    bearer_token binary(15) primary key,
    user_id int not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(id) on delete cascade
);
