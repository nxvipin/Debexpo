from debexpo.tests import TestController, url
from debexpo.model import meta
from debexpo.model.users import User

class TestRegisterController(TestController):

    def test_maintainer_signup(self, actually_delete_it=True):
        count = meta.session.query(User).filter(User.email=='mr_me@example.com').count()
        self.assertEquals(count, 0)

        self.app.post(url(controller='register', action='maintainer'),
                                 {'name': 'Mr. Me',
                                  'password': 'password',
                                  'password_confirm': 'password',
                                  'commit': 'yes',
                                  'email': 'mr_me@example.com'})

        count = meta.session.query(User).filter(User.email=='mr_me@example.com').count()
        self.assertEquals(count, 1)

        user = meta.session.query(User).filter(User.email=='mr_me@example.com').one()
        # delete it
        if actually_delete_it:
            meta.session.delete(user)
        else:
            return user

    def test_maintainer_signup_with_duplicate_name(self):
        self.test_maintainer_signup(actually_delete_it=False)

        self.app.post(url(controller='register', action='maintainer'),
                                 {'name': 'Mr. Me',
                                  'password': 'password',
                                  'password_confirm': 'password',
                                  'commit': 'yes',
                                  'email': 'mr_me_again@example.com'})

        count = meta.session.query(User).filter(User.email=='mr_me_again@example.com').count()
        self.assertEquals(count, 0)
        # The assertion is that there are no matching users by
        # email address.
        #
        # That is because both user accounts have the same name,
        # and that is not permitted by the backend.
        #
        # You might think it's silly to assert that we don't
        # do anything. Really, the point is to make sure that
        # the backend does not crash; before we wrote this test,
        # this case would actuallly raise an unhandled
        # IntegrityError from the database.

        # Now, finally, delete that User that we created.
        meta.session.delete(
            meta.session.query(User).filter(User.email=='mr_me@example.com').one())


