from collections.abc import MutableMapping, Mapping

class CaseInsensitiveDict(MutableMapping):

    """A case-insensitive ``dict``-like object.
    Implements all methods and operations of
    ``collections.MutableMapping`` as well as dict's ``copy``. Also
    provides ``lower_items``.
    All keys are expected to be strings. The structure remembers the
    case of the last key to be set, and ``iter(instance)``,
    ``keys()``, ``items()``, ``iterkeys()``, and ``iteritems()``
    will contain case-sensitive keys. However, querying and contains
    testing is case insensitive::
        cid = CaseInsensitiveDict()
        cid['Accept'] = 'application/json'
        cid['aCCEPT'] == 'application/json'  # True
        list(cid) == ['Accept']  # True
    For example, ``headers['content-encoding']`` will return the
    value of a ``'Content-Encoding'`` response header, regardless
    of how the header name was originally stored.
    If the constructor, ``.update``, or equality comparison
    operations are given keys that have equal ``.lower()``s, the
    behavior is undefined.
    """

    def __init__(self, data=None, **kwargs):
        self._store = {}
        if data is None:
            data = {}
        self.update(data, **kwargs)

    def __setitem__(self, key, value):
        # Use the lowercased key for lookups, but store the actual
        # key alongside the value.
        self._store[key.lower()] = (key, value)

    def __getitem__(self, key):
        return self._store[key.lower()][1]

    def __delitem__(self, key):
        del self._store[key.lower()]

    def __iter__(self):
        return (casedkey for casedkey, mappedvalue in self._store.values())

    def __len__(self):
        return len(self._store)

    def lower_items(self):
        """Like iteritems(), but with all lowercase keys."""
        return (
            (lowerkey, keyval[1])
            for (lowerkey, keyval)
            in self._store.items()
        )

    def __eq__(self, other):
        if isinstance(other, Mapping):
            other = CaseInsensitiveDict(other)
        else:
            return NotImplemented
        # Compare insensitively
        return dict(self.lower_items()) == dict(other.lower_items())

    # Copy is required
    def copy(self):
        return CaseInsensitiveDict(self._store.values())

    def __repr__(self):
        return str(dict(self.items()))


class Group(CaseInsensitiveDict):
    pass


class Block(CaseInsensitiveDict):
    pass


class Variable:
    """Data container for variables"""

    def __init__(self, name="", sets="", label=""):
        if not name:
            name = ""
        if not sets:
            sets = ""
        if not label:
            label = ""
        self.name = name
        self.sets = sets
        self.label = label


class Equation:
    """Data container for equations"""

    def __init__(self, name="", sets="", conditions="", LHS="", RHS=""):
        self.name = name
        self.sets = sets.lower()
        self.conditions = conditions.lower()
        self.LHS = LHS
        self.RHS = RHS

        self._name = name[1:]  #  Name without E, usefull as slicing is not usable in python string format method


class Function:
    """Data container for user defined functions"""
    def __init__(self, name, args, expression):
        self.name = name.lower()
        self.args = [arg.strip() for arg in args.split(",")]
        self.expression = expression


class MockMatch:
    def __init__(self, *groups):
        self.groups = [*groups]
        self.groups = ["".join(self.groups)] + self.groups

    def group(self, i):
        return self.groups[i]

    def groups(self, i):
        return self.groups

