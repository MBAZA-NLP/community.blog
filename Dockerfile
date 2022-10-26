FROM ghost:5.20.0-alpine as cloudinary
WORKDIR $GHOST_INSTALL/current
RUN su-exec node yarn add ghost-storage-cloudinary@2

FROM ghost:5.20.0-alpine
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/node_modules $GHOST_INSTALL/current/node_modules
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/node_modules/ghost-storage-cloudinary $GHOST_INSTALL/current/core/server/adapters/storage/ghost-cloudinary-store
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/node_modules/ghost-storage-cloudinary $GHOST_INSTALL/content/adapters/ghost-cloudinary-store
# COPY ./ghost_config/email/templates/invite-user.html $GHOST_INSTALL/current/core/server/services/mail/templates/invite-user.html
# COPY ./ghost_config/email/templates/welcome.html $GHOST_INSTALL/current/core/server/services/mail/templates/welcome.html

RUN set -ex; \
    su-exec node ghost config storage.active ghost-storage-cloudinary; \
    su-exec node ghost config storage.ghost-storage-cloudinary.upload.use_filename true; \
    su-exec node ghost config storage.ghost-storage-cloudinary.upload.unique_filename true; \
    su-exec node ghost config storage.ghost-storage-cloudinary.upload.overwrite false; \
    su-exec node ghost config storage.ghost-storage-cloudinary.fetch.quality auto; \
    su-exec node ghost config storage.ghost-storage-cloudinary.fetch.cdn_subdomain true;
