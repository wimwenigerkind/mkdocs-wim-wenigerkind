## Grundbefehle in Git

1. **`git init`**
   Initialisiert ein neues Git-Repository in dem aktuellen Verzeichnis. Damit wird der Ordner für die Versionskontrolle vorbereitet.

2. **`git clone [URL]`**
   Klont ein bestehendes Repository von einer URL (z.B. GitHub) auf den lokalen Computer.

3. **`git status`**
   Zeigt den aktuellen Status des Repositories an, inklusive Änderungen, die zum Commit anstehen.

4. **`git add [Datei]`**
   Fügt eine Datei zur Staging-Area hinzu, um sie für den nächsten Commit vorzubereiten.

5. **`git commit -m "Nachricht"`**
   Speichert die Änderungen in der Staging-Area als neuen Commit mit einer Beschreibung.

6. **`git push`**
   Überträgt die lokalen Commits zum entfernten Repository, z.B. auf GitHub.

7. **`git pull`**
   Holt die neuesten Änderungen vom entfernten Repository und integriert sie in das aktuelle lokale Verzeichnis.

8. **`git fetch`**
   Lädt die neuesten Änderungen vom entfernten Repository herunter, ohne sie zu integrieren.

9. **`git merge [Branch-Name]`**
   Integriert die Änderungen eines anderen Branches in den aktuellen Branch.

10. **`git branch`**
    Listet alle lokalen Branches auf und zeigt den aktuellen Branch an.

11. **`git checkout [Branch-Name]`**
    Wechselt zu einem anderen Branch oder stellt einen älteren Commit wieder her.

12. **`git log`**
    Zeigt den Verlauf der Commits an, inklusive Nachrichten, Autoren und Zeitstempel.

13. **`git reset [Datei]`**
    Entfernt eine Datei aus der Staging-Area, ohne die Datei selbst zu ändern.

14. **`git rm [Datei]`**
    Entfernt eine Datei aus dem Arbeitsverzeichnis und markiert die Löschung für den nächsten Commit.

15. **`git stash`**
    Speichert ungespeicherte Änderungen temporär, um an etwas anderem zu arbeiten, ohne sie zu committen.

16. **`git rebase [Branch-Name]`**
    Wendet Commits eines Branches auf die Spitze eines anderen Branches an und sorgt so für eine lineare Historie.

17. **`git remote -v`**
    Zeigt die verbundenen entfernten Repositories an und deren URLs.

18. **`git diff`**
    Zeigt die Unterschiede zwischen Arbeitsverzeichnis, Staging-Area und den letzten Commits an.

19. **`git tag [Tag-Name]`**
    Markiert einen bestimmten Punkt in der Commit-Historie, meist für Versionsveröffentlichungen.

20. **`git config`**
    Konfiguriert Benutzereinstellungen für Git, z.B. Name und E-Mail-Adresse.

