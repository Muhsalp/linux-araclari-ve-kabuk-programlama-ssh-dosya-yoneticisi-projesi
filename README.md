# Linux Araçları ve Kabuk Programlama SSH Dosya Yöneticisi Projesi

## Seçtiğim Proje Konusu
**`ssh`/`scp`:** Uzak bilgisayara bağlanma, dosya yönetimi ve aktarımı aracı arayüzü

## Proje Açıklaması
Uzak bilgisayara SSH bağlantısı ile bağlanarak GUI veya TUI arayüzleri üzerinden dizinlerde gezinme, dosya görüntüleme, yeniden adlandırma, silme, yerel bilgisayara aktarma, karşıya dosya gönderme işlemlerini yapabileceğiniz bir dosya yöneticisi.

## Nasıl Çalıştırılır?
- **GUI modu:** `sshdosyayoneticisi.sh --gui`
- **TUI modu:** `sshdosyayoneticisi.sh --tui`

## Ekran Görüntüleri
### GUI modunda bağlantı bilgilerini girme
![GUI Modu Görüntü 1](goruntu/gui1.png)
### GUI modunda dizinlerde gezinme
![GUI Modu Görüntü 2](goruntu/gui2.png)
### GUI modunda dosya görüntüleme
![GUI Modu Görüntü 3](goruntu/gui3.png)
### GUI modunda yeniden adlandırma
![GUI Modu Görüntü 4](goruntu/gui4.png)
### GUI modunda silme
![GUI Modu Görüntü 5](goruntu/gui5.png)
### GUI modunda yerel bilgisayara aktarma
![GUI Modu Görüntü 6](goruntu/gui6.png)
### GUI modunda karşıya dosya gönderme
![GUI Modu Görüntü 7](goruntu/gui7.png)
### TUI modunda bağlantı bilgilerini girme
![TUI Modu Görüntü 1](goruntu/tui1.png)
### TUI modunda dizinlerde gezinme
![TUI Modu Görüntü 2](goruntu/tui2.png)
### TUI modunda yapılacak işlemi seçme
![TUI Modu Görüntü 3](goruntu/tui3.png)
### TUI modunda dosya görüntüleme
![TUI Modu Görüntü 4](goruntu/tui4.png)
### TUI modunda yeniden adlandırma
![TUI Modu Görüntü 5](goruntu/tui5.png)
### TUI modunda silme
![TUI Modu Görüntü 6](goruntu/tui6.png)
### TUI modunda yerel bilgisayara aktarma
![TUI Modu Görüntü 7](goruntu/tui7.png)
### TUI modunda karşıya dosya gönderme
![TUI Modu Görüntü 8](goruntu/tui8.png)

## Kullanılan Araçlar
- **Programlama Dili:** Shell Script (Bash)
- **GUI (Grafik Arayüz):** YAD (Yet Another Dialog)
- **TUI (Metin Arayüz):** Whiptail

## Bağımlılıklar
- **`yad`:** Grafik arayüz için
- **`whiptail`:** Metin arayüz için
- **`ssh`:** Uzak bilgisayar bağlantısı için
- **`sshpass`:** Bağlantıya şifre gönderimi için
- **`scp`:** Bilgisayarlar arası dosya aktarımı için
