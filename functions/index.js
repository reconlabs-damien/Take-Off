const functions = require('firebase-functions');


const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase)

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase LBTA!");
});

exports.sendFollowerNotification = functions.database.ref('/following/{followedUid}/{followerUid}')
    .onCreate(async (change, context) => {
      const followerUid = context.params.followerUid;
      const followedUid = context.params.followedUid;
      // If un-follow we exit the function.
      console.log('We have a new follower UID:', followerUid, 'for user:', followedUid);
      return admin.database().ref('/users/' + followedUid).once('value', async snapshot => {
        // Get the list of device notification tokens.
        const getDeviceTokensPromise = snapshot.val()
        return admin.database().ref('/users/' + followerUid).once('value', async snt => {
            console.log(getDeviceTokensPromise)
            // Get the follower profile.
            var getFollowerProfilePromise = snt.val()

          // Notification details.
          const payload = {
            notification: {
              title: 'You have a new follower!',
              body: `${getDeviceTokensPromise.username} is now following you.`
            }

          };

        // Send notifications to all tokens.
          return admin.messaging().sendToDevice(getFollowerProfilePromise.fcmToken, payload)

        // For each message check if there was an error.
        });
      });
    });


    exports.sendCalendarEvent = functions.database.ref('/calendars/{calendarUid}/{eventUid}')
        .onCreate(async (change, context) => {
          const userUid = context.params.eventUid
          // If un-follow we exit the function.
          console.log('We have a new event:',userUid);
          return admin.database().ref('/calendars/' + calendarUid + '/' + userUid).once('value', async snap => {
            const tmp = snap.val()
            return admin.database().ref('/following/' + tmp.user).once('value', async snapshot => {
              // Get the list of device notification tokens.
              const followerUid = snapshot.val()
              for (var i in followerUid) {
                return admin.database().ref('/users/' + i).once('value', async snt => {
                  var follower = snt.val()
                  const payload = {
                    notification: {
                      title: '새로운 이벤트',
                      body: `${tmp.dday}에 새로운 이벤트가 생겼습니다!`
                    }
                  };
                return admin.messaging().sendToDevice(follower.fcmToken, payload)

               });
             }
            });
          })

        });
