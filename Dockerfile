# We will have two distinctly different sections: one for the build phase,
# one for the run phase. The setup of the build phase is similar to that in
# Dockerfile.dev

# Notice now, for the build phase, we don't need to set up volumes because we
# don't need changes in local files to be refelected when running up in prod
# environment

# We tag this phase with a name using the 'as' keyword.
FROM node:16-alpine as builder

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .

# N.B. the RUN instruction builds the build folder in the cwd. So the path to
# that directory within the container will be /app/build
RUN npm run build

# To specify the start of a second phase we just use the FROM command again
FROM nginx
EXPOSE 80
# Copy the build folder we just created into the new nginx container we are
# creating
# --from=stage copy from the phase with name "stage"
# we need to copy the build folder into /usr/share/nginx/html in order to get
# nginx to automatically serfe it up when it is run
# the default command within the nginx image automatically starts nginx so we
# don't need to explicitly start it in this dockerfile.
COPY --from=builder /app/build /usr/share/nginx/html


