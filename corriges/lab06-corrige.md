# 📕 Corrigé formateur — Lab 06

![Formateur](https://img.shields.io/badge/Corrigé-formateur-dc2626) · Fil rouge : [`solutions/lab06/`](../solutions/lab06/)

## ⏱️ Déroulé conseillé (45 min)

| Min | Activité |
|---|---|
| 0–10 | Connection + provisioners |
| 10–35 | Observation (0 changement), `-replace` (la recréation + Apache prend ~4 min), test de l'URL |
| 35–45 | Questions ; en discussion : provisioners ou cloud-init (`custom_data`) ? |

## ✏️ Réponses aux TODO

| TODO | Réponse |
|---|---|
| 1 | `var.private_key` |
| 2 | `"sudo bash /tmp/assets/setup-web.sh"` |
| 3 | `Apply complete! Resources: 0 added, 0 changed, 0 destroyed.` (+ l'output `url` si ajouté). Les provisioners ne font pas partie de l'état de la ressource : les ajouter ne crée aucune différence entre code et état. Ils ne s'exécutent qu'à la **création**. |

## ❓ Réponses aux questions

1. Une ressource ne peut pas se référencer par son adresse dans sa propre définition (cycle) ; `self` est la seule façon de lire ses propres attributs dans `connection` et les provisioners.
2. Elle est marquée **tainted** : le prochain `apply` la détruit et la recrée.

## 🧯 Pièges observés en session

- 🟥 IP du poste changée entre deux labs (Wi-Fi) : provisioner en timeout → VM tainted. Toujours vérifier `allowed_ssh_cidr`.
- 🟧 `assets/` créé dans `modules/server/` au lieu de la racine : `path.root` ne le trouve pas.
- 🟨 Les labs 12 (HCP Terraform) se connectent en SSH **depuis les runners HCP** : il faudra alors ouvrir le port 22 à Internet. À anticiper dans le discours.
