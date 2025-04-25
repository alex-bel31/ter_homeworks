# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

## Задание 1

Ошибка в значении атрибута platform_id. Платформы standart-v4 не существует.

```ps1
platform_id = "standart-v4"
```

Указана недопустимая гарантированная доля vCPU на платформе «standard-v3», допустимые фракции ядра: 20, 50, 100.
Указано количество ядер недоступно на платформе «standard-v3», допустимое количество ядер: 2 до 96

- Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ
    - Сильно дешевле обычных ВМ.

## Задание 2 

```s
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
```

*картинка terraform plan*

## Задание 3 

Перменные относящиеся к ВМ были вынесены в файл **vms_platform.tf**.
Созданы две виртуальные машины работающих в разных зонах:
- web_platform с параметрами из переменных vm_web_*
- db_platform с параметрами из vm_db_*

*картинка yc-t3*

## Задание 4 

Был создан блок `output "instances_info"` содержащий: instance_name, external_ip, fqdn для каждой из ВМ.
Тип данных для `instances_info` - **map(map())**, где каждый элемент описывает ВМ и её атрибуты.

## Задание 5

В блоке `locals` создали локальные переменные `vm_web_name` и v`m_db_name` с использованием интерполяции значений из списка переменной `var.vm_name`.


```s
locals {
  vm_web_name = "netology-develop-platform-${var.vm_name[0]}"
  vm_db_name  = "netology-develop-platform-${var.vm_name[1]}"
}
```
## Задание 6

Задал перменную `vms_resources` которая представляет собой `map(object)`, где ключами являются имена виртуальных машин, а значениями объекты с параметрами конфигурации ВМ.

```s
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    vm_web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    vm_db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
  description = "Defines resource configuration for VM"
}
```

Создаем переменная `vms_metadata` типа **map(string)** с двумя ключами: `"serial-port-enable"` и `"ssh-keys"`.

```c
variable "vms_metadata" {
  type = map(string)
  default = {
    "serial-port-enable" = "1"
    "ssh-keys"           = "ubuntu:ssh-ed25519 xxxxxxx"
  }
  sensitive = true
}
```

## Задание 7*


В качестве решения предоставьте необходимые команды и их вывод.

> length(local.test_list)
> local.test_map["admin"]
> values(local.test_map)
>"${local.test_map["admin"]} is ${keys(local.test_map)[0]} for ${local.test_list[2]} server based on OS ${local.servers["stage"].image} with ${local.servers["stage"].cpu} vcpu, ${local.servers["stage"].ram} ${keys(local.servers["stage"])[3]} and ${length(local.servers["stage"].disks)} virtual disks"
"John is admin for production server based on OS ubuntu-20-04 with 4 vcpu, 8 ram and 2 virtual disks"

*картинка t7*

## Задание 8
Тип переменной был задан как:
```py
type = list(map(list(string)))
```
выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" выглядит следующим образом:

> var.test[0].dev1[0]
"ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"

## Задание 9

Вот описание проделанной работы по настройке выхода в интернет для виртуальных машин в приватных подсетях через NAT-шлюз в Yandex Cloud:

---

## 📄 Описание проделанной работы

### 1. 🔧 Обновление существующих подсетей

Ранее были созданы две подсети в VPC-сети `develop`:

- `web_develop` — в зоне `${var.vm_web_zone}`
- `db_develop` — в зоне `${var.vm_db_zone}`

В каждую из них была **добавлена строка**:

```hcl
route_table_id = yandex_vpc_route_table.rt.id
```

Это позволяет подсетям использовать таблицу маршрутизации с маршрутом через NAT-шлюз, чтобы машины из этих подсетей могли выходить в интернет.

---

### 2. 🌐 Создание NAT-шлюза

Был создан ресурс:

```hcl
resource "yandex_vpc_gateway" "nat_gateway"
```

С параметром `shared_egress_gateway {}` — это значит, что шлюз предназначен для общего исходящего трафика из внутренних подсетей.

---

### 3. 🧭 Создание таблицы маршрутизации

Создана таблица маршрутизации `yandex_vpc_route_table.rt`, в которую добавлен маршрут:

```hcl
static_route {
  destination_prefix = "0.0.0.0/0"
  gateway_id         = yandex_vpc_gateway.nat_gateway.id
}
```

Это означает: весь внешний трафик (весь интернет) должен направляться через NAT-шлюз.

---

### 4. 🧑‍💻 Подключение к ВМ и настройка доступа

Предварительно было выполнено подключение к виртуальным машинам через `ssh`, после чего:

- Был **задан пароль пользователю**
- Это необходимо для возможности входа в ВМ через **серийную консоль** (например, при потере SSH-доступа)

---

### 5. 📸 Проверка отсутствия публичных IP и доступности интернета

- Был сделан **скриншот интерфейса ВМ**, на котором видно, что:
  - У машин **нет публичных IP-адресов**
  - Пинг до `ya.ru` **успешен**, что подтверждает выход в интернет через NAT-шлюз

  *2 картинки t9*