import 'package:image/image.dart' as img;

import 'package:onionchatflutter/util/connection_helper.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';

class AvatarRepository {
  final VCardManager _vCardManager;
  final Map<String, img.Image> _avatars = {};
  final img.Image _def;

  AvatarRepository(this._vCardManager, this._def);

  Future<img.Image> fetchAvatar(String username) async {
    final avatar = _avatars[username];
    if (avatar == null) {
      final vcard = await _vCardManager.getVCardFor(username.toJid());
      _avatars[username] = vcard.image ?? _def;
    }
    return _avatars[username]!;
  }
}